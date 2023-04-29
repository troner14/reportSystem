---@class typeofreports
---@field typeofreports { value : string, label: string}[]
---@field menuPosition 'top-left' | 'top-right' | 'bottom-left' |'bottom-right'
Config = {}

Config.Locale = GetConvar('esx:locale', 'es')

Config.menuPosition = "bottom-right"
Config.typeofreports = {
    { value="bug", label="bug"},
    { value="antirol", label="antirol"},
}

Config.reportOptions = {
    teleport = true,
    discord = true,
}