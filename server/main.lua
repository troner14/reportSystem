AdminReportEnabled = {}

local function getAllReports(callback)
    MySQL.query("SELECT * FROM reportsystem WHERE fecha >= DATE_SUB(NOW(), INTERVAL 5 HOUR)", function(result)
        callback(result)
    end)
end

local function newReport(data, callback)
    MySQL.query("INSERT INTO reportsystem (licence, name, descripcion, tipo) VALUES (?, ?, ?, ?)",{ data.licence, data.name, data.descripcion, data.tipo }, function(result)
        callback(result)
    end)
end

RegisterServerEvent("reportSys:server:newReport", function(data)
    local src = source
    newReport(data, function(res)
        if (res.affectedRows) then
            TriggerClientEvent('ox_lib:notify', src, {
                id = "newReport_Notify",
                title = TranslateCap('ox_lib.notify.title'),
                description = TranslateCap('ox_lib.notify.newReport.description'),
            })

            local xAdmins = ESX.GetExtendedPlayers("group", "admin")
            for _,xPlayer in pairs(xAdmins) do
                if (AdminReportEnabled[xPlayer.identifier]) then
                    TriggerClientEvent('reportSys:client:AlertAdmin', xPlayer.source, data)
                end
            end
        end
    end)
end)

RegisterServerEvent("reportSys:server:closeReport", function(id)
    local src = source
    MySQL.query("DELETE FROM reportsystem WHERE id = ?", { id }, function(res)
        if (res.affectedRows) then
            TriggerClientEvent('ox_lib:notify', src, {
                id = "newReport_Notify_del",
                title = TranslateCap('ox_lib.notify.title'),
                description = TranslateCap('ox_lib.notify.closeReport.description'),
            })
        end
    end)
end)

RegisterServerEvent("reportSys:server:Teleport", function(identifier)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromIdentifier(identifier)

    if (xPlayer.identifier == xTarget.identifier) then
        xPlayer.triggerEvent("ox_lib:notify", {
            id = "newReport_Notify",
            title = TranslateCap('ox_lib.notify.title'),
            description = TranslateCap('ox_lib.notify.teleport.notteleporttoyourself'),
            type = 'error'
        })
    else
        xPlayer.triggerEvent("ox_lib:notify", {
            id = "newReport_Notify",
            title = TranslateCap('ox_lib.notify.title'),
            description = TranslateCap('ox_lib.notify.teleport.xplayermessage', xTarget.name),
        })
        xPlayer.setCoords(xTarget.getCoords())
        xTarget.triggerEvent("ox_lib:notify", {
            id = "newReport_Notify",
            title = TranslateCap('ox_lib.notify.title'),
            description = TranslateCap('ox_lib.notify.teleport.tplayermessage', GetPlayerName(xPlayer.source)),
        })
    end
end)

RegisterServerEvent("reportSys:server:DiscSend", function(identifier)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromIdentifier(identifier)
    
    xTarget.triggerEvent("ox_lib:notify", {
        id = "newReport_Notify",
        title = TranslateCap('ox_lib.notify.title'),
        description = TranslateCap("ox_lib.notify.DiscSend.description", GetPlayerName(xPlayer.source)),
    })
end)


ESX.RegisterCommand("getreports", "admin", function(xPlayer, args, showError)
    getAllReports(function(res)
        if (#res == 0) then
            xPlayer.triggerEvent("ox_lib:notify", {
                id = "newReport_Notify",
                title = "Reporte",
                description = "no hay reportes que mostrar",
                type = 'error'
            })
            return;
        else
            TriggerClientEvent("reportSys:client:openReportsMenu", xPlayer.source, res)
        end
    end);
end, false)

ESX.RegisterCommand("report", "user", function(xPlayer, args, showError)
    local data = {
        licence = xPlayer.identifier,
        name = xPlayer.name
    }
    TriggerClientEvent("reportSys:client:openReportMenu", xPlayer.source, data)
end, false)

ESX.RegisterCommand("togglereports", "admin", function (xPlayer, args, rawCommand)
    if (AdminReportEnabled[xPlayer.identifier]) then
        AdminReportEnabled[xPlayer.identifier] = not AdminReportEnabled[xPlayer.identifier]
    else
        local meta = xPlayer.getMeta()
        if (not meta.reportes) then
            xPlayer.setMeta("reportes", {enabled = false})
        end
        local reportEnabled = xPlayer.getMeta("reportes", "enabled")
        AdminReportEnabled[xPlayer.identifier] = reportEnabled
    end

    local description
    if (AdminReportEnabled[xPlayer.identifier]) then
        description = TranslateCap('command.togglereport.description.true')
    else
        description = TranslateCap('command.togglereport.description.false')
    end


    xPlayer.triggerEvent("ox_lib:notify", {
        id = "newReport_Notify",
        title = "Reporte",
        description = description,
    })
end)

AddEventHandler("esx:playerLoaded", function(player, xPlayer)
    if (xPlayer.group == "admin") then
        local meta = xPlayer.getMeta()
        if (not meta.reportes) then
            xPlayer.setMeta("reportes", {enabled = false})
        end
        local reportEnabled = xPlayer.getMeta("reportes", "enabled")
        AdminReportEnabled[xPlayer.identifier] = reportEnabled
    end
end)


if (Config.CleanSQLeveryDay) then
    function ClearSQL()
        MySQL.query("DELETE FROM reportsystem WHERE DATE(fecha) = DATE(DATE_SUB(NOW(), INTERVAL 1 DAY))")
    end

    -- lib.cron.new('0 21 * * *', learSQL)
    TriggerEvent("cron:runAt", 21, 0, clearSQL)
end