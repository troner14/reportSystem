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
                title = "Reporte",
                description = "reporte enviado de manera existosa",
            })
        end
    end)
end)

RegisterServerEvent("reportSys:server:closeReport", function(id)
    local src = source
    MySQL.query("DELETE FROM reportsystem WHERE id = ?", { id }, function(res)
        if (res.affectedRows) then
            TriggerClientEvent('ox_lib:notify', src, {
                id = "newReport_Notify_del",
                title = "Reporte",
                description = "reporte eliminiado",
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
            title = "Reporte",
            description = "no puedes tepearte a ti mismo.",
            type = 'error'
        })
    else
        xPlayer.triggerEvent("ox_lib:notify", {
            id = "newReport_Notify",
            title = "Reporte",
            description = "te teletrasportaste a "..xTarget.name,
        })
        xPlayer.setCoords(xTarget.getCoords())
        xTarget.triggerEvent("ox_lib:notify", {
            id = "newReport_Notify",
            title = "Reporte",
            description = GetPlayerName(xPlayer.source).."se teletrasporto a ti para atender el ticket.",
        })
    end
end)

RegisterServerEvent("reportSys:server:DiscSend", function(identifier)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromIdentifier(identifier)

    xTarget.triggerEvent("ox_lib:notify", {
        id = "newReport_Notify",
        title = "Reporte",
        description = "el administrador "..GetPlayerName(xPlayer.source).." te pide en sala de soporte de discord para atender tu reporte.",
    })
end)


ESX.RegisterCommand("getReports", "admin", function(xPlayer, args, showError)
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
    print(xPlayer.identifier)
    TriggerClientEvent("reportSys:client:openReportMenu", xPlayer.source, data)
end, false)


if (Config.CleanSQLeveryDay) then
    function clearSQL()
        MySQL.query("DELETE FROM reportsystem WHERE DATE(fecha) = DATE(DATE_SUB(NOW(), INTERVAL 1 DAY))")
    end

    TriggerEvent("cron:runAt", 21, 0, clearSQL)
end
