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

            local xAdmins = Config.GetAllAdmins()
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
    local xPlayer = Config.GetPlayerFromId(src)
    local xTarget = Config.GetPlayerFromIdentifier(identifier)

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
    local xPlayer = Config.GetPlayerFromId(src)
    local xTarget = Config.GetPlayerFromIdentifier(identifier)

    xTarget.triggerEvent("ox_lib:notify", {
        id = "newReport_Notify",
        title = TranslateCap('ox_lib.notify.title'),
        description = TranslateCap("ox_lib.notify.DiscSend.description", GetPlayerName(xPlayer.source)),
    })
end)


Config.RegisterCommand("getReports", Config.RoleToGetReports, function(xPlayer, args)
    getAllReports(function(res)
        if (#res == 0) then
            xPlayer.triggerEvent("ox_lib:notify", {
                id = "newReport_Notify",
                title = TranslateCap('ox_lib.notify.title'),
                description = TranslateCap('command.getReports.notify.notReports'),
                type = 'error'
            })
            return;
        else
            TriggerClientEvent("reportSys:client:openReportsMenu", xPlayer.source, res)
        end
    end);
end, false)

Config.RegisterCommand("report", "user", function(xPlayer, args)
    local data = {
        licence = xPlayer.identifier,
        name = xPlayer.name
    }
    TriggerClientEvent("reportSys:client:openReportMenu", xPlayer.source, data)
end, false)

-- Config.RegisterCommand("testgetadmins", Config.RoleToGetReports, function (xPlayer, args)
--     print(Config.GetAllAdmins())
-- end)

Config.RegisterCommand("togglereports", Config.RoleToGetReports, function (xPlayer, args)
    if (type(AdminReportEnabled[xPlayer.identifier]) ~= "nil") then
        AdminReportEnabled[xPlayer.identifier] = not AdminReportEnabled[xPlayer.identifier]
    else
        local meta = xPlayer.getMeta()
        if (not meta.reportes) then
            xPlayer.setMeta("reportes", {enabled = false})
        end
        local reportEnabled = xPlayer.getMeta("reportes").enabled
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
        title = TranslateCap('ox_lib.notify.title'),
        description = description,
    })
end)

if (Config.framework == "ESX") then
    AddEventHandler("esx:playerLoaded", function(player, xPlayer)
        if (xPlayer.group == Config.RoleToGetReports) then
            local meta = xPlayer.getMeta()
            if (not meta.reportes) then
                xPlayer.setMeta("reportes", {enabled = false})
            end
            local reportEnabled = xPlayer.getMeta("reportes", "enabled")
            AdminReportEnabled[xPlayer.identifier] = reportEnabled
        end
    end)
end


if (Config.CleanSQLeveryDay) then
    function ClearSQL()
        MySQL.query("DELETE FROM reportsystem WHERE DATE(fecha) = DATE(DATE_SUB(NOW(), INTERVAL 1 DAY))")
    end
    if (Config.framework == "ESX") then
        TriggerEvent("cron:runAt", 21, 0, ClearSQL)
    else
        if (exports["qb-smallresources"].CreateTimedJob) then
            exports["qb-smallresources"]:CreateTimedJob(21, 0, ClearSQL)
        else
            print("export of cron in qb-smallresources dosn't exist \n verify if you have latest version of qb-smallresources")
        end
    end
end