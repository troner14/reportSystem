---@class typeofreports
---@field menuPosition 'top-left' | 'top-right' | 'bottom-left' |'bottom-right'
---@field typeofreports { value : string, label: string}[]
---@field CleanSQLeveryDay boolean
Config = {}

Config.Locale = GetConvar('esx:locale', 'es')

Config.menuPosition = "bottom-right"
Config.typeofreports = {
    { value="bug", label="bug"},
    { value="antirol", label="antirol"},
}
-- if this is true when new report is create all admin with reports enabled recibed a notify with the new report
Config.notifyAdmins = true

--need cron script
Config.CleanSQLeveryDay = true --false if you don't have cron script

Config.reportOptions = {
    teleport = true,
    discord = true,
}