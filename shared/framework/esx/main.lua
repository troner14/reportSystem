if (Config.framework ~= "ESX") then return end

Config.GetAllAdmins = function()
    if (Config.frameworkVersion == "legacy") then
        if (type(Config.RoleToGetReports) == "table") then
            local xAdmins = {}
            for _,rank in pairs(Config.RoleToGetReports) do
                local xranks = ESX.GetExtendedPlayers("group", rank)
                for _,xply in pairs(xranks)  do
                    xAdmins[#xAdmins+1] = xply
                end
            end
            return xAdmins
        else
            return ESX.GetExtendedPlayers("group", Config.RoleToGetReports)
        end
    else
        local xAdmins = {}
        local xPlayers = ESX.GetPlayers()

        for _, playerid in pairs(xPlayers) do
            local xPlayer = ESX.GetPlayerFromId(playerid)
            if (type(Config.RoleToGetReports) == "table") then
                for _,rank in pairs(Config.RoleToGetReports) do
                    if (xPlayer.group == rank) then
                        xAdmins[#xAdmins+1] = xPlayer
                    end
                end
            else
                if (xPlayer.group == Config.RoleToGetReports) then
                    xAdmins[#xAdmins+1] = xPlayer
                end
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