if (Config.framework ~= "ESX") then return end

Config.GetAllAdmins = function()
    if (Config.frameworkVersion == "legacy") then
       return ESX.GetExtendedPlayers("group", Config.RoleToGetReports)
    else
        local xAdmins = {}
        local xPlayers = ESX.GetPlayers()

        for _, playerid in pairs(xPlayers) do
            local xPlayer = ESX.GetPlayerFromId(playerid)
            if (xPlayer.group == Config.RoleToGetReports) then
                xAdmins[#xAdmins+1] = xPlayer
            end
        end

        return xAdmins
    end
end

Config.GetPlayerFromId = function(source)
    return ESX.GetPlayerFromId(source)
end

Config.GetPlayerFromIdentifier  = function(identifier)
    return ESX.GetPlayerFromIdentifier(identifier)
end

Config.RegisterCommand = function(name, group, cb, CanConsole)
    ESX.RegisterCommand(name, group, cb, CanConsole)
end