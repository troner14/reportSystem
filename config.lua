---@class typeofreports
---@field menuPosition 'top-left' | 'top-right' | 'bottom-left' |'bottom-right'
---@field typeofreports { value : string, label: string}[]
---@field CleanSQLeveryDay boolean
Config = {}
Config.EsVersion = "legacy"

---@type "es" | "en"
Config.Locale = "en"

Config.menuPosition = "bottom-right"
Config.typeofreports = {
    { value="bug", label="bug"},
    { value="antirol", label="antirol"},
}
-- if this is true when new report is create all admin with reports enabled recibed a notify with the new report
Config.notifyAdmins = true

Config.RoleToGetReports="admin"

--need cron script or in qb-core using qb-smallresources
Config.CleanSQLeveryDay = true --false if you don't have cron /qb-smallresources script

Config.reportOptions = {
    teleport = true,
    discord = true,
}

function loadModule(file)
    local mod = LoadResourceFile(GetCurrentResourceName(), file)
    local modload, e = load(mod)
    if (e) then return print(e) end
    modload()
end

loadModule("shared/framework.lua")