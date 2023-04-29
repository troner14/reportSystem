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

--need cron script
Config.CleanSQLeveryDay = true --false if you don't have cron script

Config.reportOptions = {
    teleport = true,
    discord = true,
}