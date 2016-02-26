#
# Copyright (C) 2008-2014 The LuCI Team <luci@lists.subsignal.org>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=Easy link merge based on mwan3 LuCI page
LUCI_DEPENDS:=+link-merge

include $(TOPDIR)/feeds/luci/luci.mk
#include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature
