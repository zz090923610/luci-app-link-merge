require("luci.tools.webadmin")
require("luci.sys")
require("luci.sys.zoneinfo")
require("luci.config")
local fs = require "nixio.fs"
local ut = require "luci.util"
local pt = require "luci.tools.proto"
local nw = require "luci.model.network"
local fw = require "luci.model.firewall"
--[[


]]--

local sys = require "luci.sys"

m = Map("first_config", translate("link-merge","link-merge"),
                translate("link-merge title desc","link-merge title desc"))

s = m:section(TypedSection, "first_config", translate("Network Authentication Settings."))
s.anonymous = true
s.addremove = false

enable_multi = s:option(ListValue, "type", translate("Single Account(DHCP,PPPoE,Static) or Multiple Accounts"))
enable_multi:value("one", translate("Single")) 
enable_multi:value("multi",  translate("Multiple")) 
enable_multi.optional = false
enable_multi.rmempty = true
enable_multi.default="one"


proto = s:option(ListValue, "proto", translate("Change wan protocal type"))
proto.default = "pppoe"
proto:depends("type", "one")

local _, pr
for _, pr in ipairs(nw:get_protocols()) do
	if pr:proto() == "static" or pr:proto() == "dhcp" or pr:proto() == "pppoe" then
		proto:value(pr:proto(), pr:get_i18n())
	end
end
local ipaddr, netmask, gateway, dns
ipaddr = s:option(Value, "ipaddr", translate("static ip address"))
ipaddr.datatype = "ip4addr"
ipaddr.rmempty = true
ipaddr:depends("proto", "static")

netmask = s:option(Value, "netmask", translate("static ip netmask"))
netmask.datatype = "ip4addr"
netmask:value("255.255.255.0")
netmask:value("255.255.0.0")
netmask:value("255.0.0.0")
netmask:depends("proto", "static")
netmask.rmempty = true

gateway = s:option(Value, "gateway", translate("static ip gateway"))
gateway.datatype = "ip4addr"
gateway:depends("proto", "static")
gateway.rmempty = true

dns = s:option(DynamicList, "dns", translate("static DNS servers"))
dns.datatype = "ipaddr"
--p.cast     = "string"
dns:depends("proto", "static")
dns.rmempty = true

macaddr = s:option(DynamicList, "macaddr", translate("macaddr override"))
macaddr.datatype = "macaddr"
--p.cast     = "string"
macaddr:depends("proto", "static")
macaddr.rmempty = true


username = s:option(Value, "username", translate("pppoe username"))
username.datatype = "minlength(1)"
username:depends("proto", "pppoe")
username.rmempty = true

password = s:option(Value, "password", translate("pppoe password"))
password.password = true
password.datatype = "minlength(1)"
password:depends("proto", "pppoe")
password.rmempty = true

multi_type = s:option(ListValue, "multi_type", translate("Proto type of multi-wans"))
multi_type:value("pppoe", translate("PPPoE")) 
multi_type:value("dhcp",  translate("DHCP")) 
multi_type:depends("type", "multi")
multi_type.optional = false
multi_type.rmempty = true
multi_type.default="pppoe"

enable0 = s:option(Flag, "enabled0", translate("Enable Account 1", "Enable Account 1"))
enable0:depends("type", "multi")
enable0.default = false
enable0.optional = false
enable0.rmempty = true

AC0 = s:option(Value, "account0", translate("Account 1","Account 1"))
AC0:depends("multi_type", "pppoe")
AC0.optional = false
AC0.rmempty = true

PW0 = s:option(Value, "passwd0", translate("Password 1","Password 1"))
PW0:depends("multi_type", "pppoe")
PW0.optional = false
PW0.rmempty = true

enable1 = s:option(Flag, "enabled1", translate("Enable Account 2", "Enable Account 2"))
enable1:depends("type", "multi")
enable1.default = false
enable1.optional = false
enable1.rmempty = true

AC1 = s:option(Value, "account1", translate("Account 2","Account 2"))
AC1:depends("multi_type", "pppoe")
AC1.optional = false
AC1.rmempty = true

PW1 = s:option(Value, "passwd1", translate("Password 2","Password 2"))
PW1:depends("multi_type", "pppoe")
PW1.optional = false
PW1.rmempty = true

enable2 = s:option(Flag, "enabled2", translate("Enable Account 3", "Enable Account 3"))
enable2:depends("type", "multi")
enable2.default = false
enable2.optional = false
enable2.rmempty = true

AC2 = s:option(Value, "account2", translate("Account 3","Account 3"))
AC2:depends("multi_type", "pppoe")
AC2.optional = false
AC2.rmempty = true

PW2 = s:option(Value, "passwd2", translate("Password 3","Password 3"))
PW2:depends("multi_type", "pppoe")
PW2.optional = false
PW2.rmempty = true


enable3 = s:option(Flag, "enabled3", translate("Enable Account 4", "Enable Account 4"))
enable3:depends("type", "multi")
enable3.default = false
enable3.optional = false
enable3.rmempty = true

AC3 = s:option(Value, "account3", translate("Account 4","Account 4"))
AC3:depends("multi_type", "pppoe")
AC3.optional = false
AC3.rmempty = true

PW3 = s:option(Value, "passwd3", translate("Password 4","Password 4"))
PW3:depends("multi_type", "pppoe")
PW3.optional = false
PW3.rmempty = true

local apply = luci.http.formvalue("cbi.apply")
if apply then
    io.popen("/usr/bin/apply-link-merge &")
end


return m

