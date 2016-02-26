module("luci.controller.link-merge", package.seeall)

function index()
     require("luci.i18n")
     luci.i18n.loadc("link-merge")
    local fs = luci.fs or nixio.fs
    if not fs.access("/etc/config/first_config") then
		return
	end
	
	
	local page = entry({"admin", "network", "link-merge"}, cbi("link-merge/link-merge"), "link-merge")
	page.i18n = "link-merge"
	page.dependent = true


end
