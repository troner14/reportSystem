---@class typeofreports
---@field menuPosition 'top-left' | 'top-right' | 'bottom-left' |'bottom-right'
---@field typeofreports { value : string, label: string}[]
---@field CleanSQLeveryDay boolean
Config = {}

---@type "es" | "en" | "de" | "fr" | "nl"
Config.Locale = "en"

Config.menuPosition = "bottom-right"
Config.typeofreports = {
    { value="bug", label="bug"},
    { value="antirol", label="antirol"},
}
-- if this is true when new report is create all admin with reports enabled recibed a notify with the new report
Config.notifyAdmins = true

-- the lowest group to acces to commands of reports an notify
-- for example if you have god, admin, mod.
-- if you put mod. admins and god they will also have permission
-- in ESX legacy can use array to especcific a groups if  you want but work equals.
Config.RoleToGetReports="admin"


--need cron script or in qb-core using qb-smallresources
Config.CleanSQLeveryDay = true --false if you don't have cron /qb-smallresources script

Config.reportOptions = {
    teleport = true,
    discord = true,
}

function loadModule(file)
    local resourceName = GetCurrentResourceName()
    local mod = LoadResourceFile(resourceName, file)

    if not mod then
        print("Error: No se pudo cargar el archivo " .. file)
        return
    end

    local modload, e = load(mod)
    if not modload then
        print("Error: " .. e)
        return
    end

    modload()
end

loadModule("shared/framework.lua")
