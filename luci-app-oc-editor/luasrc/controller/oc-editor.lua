module("luci.controller.oc-editor", package.seeall)
function index()
	entry({"admin", "nas"}, firstchild(), "NAS", 44).dependent=false
	entry({"admin", "nas", "oc-editor"}, template("oc-editor"), _("Oc Editor Config"), 55).dependent=true
end
