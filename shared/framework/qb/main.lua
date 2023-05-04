
Config.GetAllAdmins = function()
    local Admins_players = {}
    local players = QBCore.Functions.GetQBPlayers()
    for _,xply in pairs(players) do
        if (QBCore.Functions.HasPermission(xply.PlayerData.source, Config.RoleToGetReports)) then
            xply.identifier = xply.PlayerData.citizenid
            xply.source     = xply.PlayerData.source
            Admins_players[#Admins_players+1] = xply
        end
    end

    return Admins_players;
end

local function xplayerModification (xplayer)
    xplayer.identifier = xplayer.PlayerData.citizenid
    xplayer.source = xplayer.PlayerData.source
    xplayer.name = xplayer.PlayerData.name
    xplayer.triggerEvent = function (EventName, ...)
        TriggerClientEvent(EventName, xplayer.PlayerData.source, ...)
    end
    xplayer.setCoords = function (coords)
        TriggerClientEvent('QBCore:Command:TeleportToPlayer', xplayer.source, coords)
    end
    xplayer.getCoords = function()
        return GetEntityCoords(xplayer.source, false)
    end
    xplayer.setMeta = xplayer.Functions.SetMetaData
    xplayer.getMeta = function(index, subIndex)
        if index then
            if xplayer.PlayerData.metadata[index] then

                if subIndex and type(xplayer.PlayerData.metadata[index]) == "table" then
                    local _type = type(subIndex)

                    if _type == "string" then
                        if xplayer.PlayerData.metadata[index][subIndex] then
                            return xplayer.PlayerData.metadata[index][subIndex]
                        end
                        return
                    end

                    if _type == "table" then
                        local returnValues = {}
                        for i = 1, #subIndex do
                            if xplayer.PlayerData.metadata[index][subIndex[i]] then
                                returnValues[subIndex[i]] = xplayer.PlayerData.metadata[index][subIndex[i]]
                            else
                                print(("[^1ERROR^7] xPlayer.getMeta ^5%s^7 not esxist on ^5%s^7!"):format(subIndex[i], index))
                            end
                        end

                        return returnValues
                    end

                end

                return xplayer.PlayerData.metadata[index]
            else
                return print(("[^1ERROR^7] xPlayer.getMeta ^5%s^7 not exist!"):format(index))
            end
        end
        return xplayer.PlayerData.metadata
    end
    return xplayer
end

Config.GetPlayerFromId = function(source)
    local xplayer = QBCore.Functions.GetPlayer(source)
    return xplayerModification(xplayer)
end

Config.GetPlayerFromIdentifier  = function(identifier)
    local xplayer = QBCore.Functions.GetPlayerByCitizenId(identifier)

    return xplayerModification(xplayer)
end


Config.RegisterCommand = function(name, group, cb, CanConsole, help, arguments, argsrequired)
    QBCore.Commands.Add(name, nil, nil, nil, function(source, args)
        local xplayer = Config.GetPlayerFromId(source)
        cb(xplayer, args)
    end, group)
end
