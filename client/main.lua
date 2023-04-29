function OpenMenu(reports)
    local options = {}
    for _,report in pairs(reports) do
        options[#options+1] = {
            label = report.name,
            description = report.descripcion,
            args = { data = report}
        }
    end

    lib.registerMenu({
        id = 'menu_reportes',
        title = TranslateCap("menu.reportes.title"),
        position = Config.menuPosition,
        options = options
    }, function (_, __, args, ___)
        local Options = {
            {label=TranslateCap("menu.reporte.options.closeReport"), description=args.data.descripcion},
        }

        if (Config.reportOptions.teleport) then
            Options[#Options+1] = {
                label=TranslateCap("menu.reporte.options.teleport"),
                description=args.data.descripcion
            }
        end
        if (Config.reportOptions.discord) then
            Options[#Options+1] = {
                label=TranslateCap("menu.reporte.options.Discordmsg"),
                description=args.data.descripcion
            }
        end

        Options[#Options+1] = {label=TranslateCap("menu.reporte.options.closeMenu")}
        lib.registerMenu({
            id = 'menu_reportes_'..args.data.name,
            title = TranslateCap("menu.reporte.title", args.data.name),
            position =Config.menuPosition,
            options = Options
        }, function (selected, _)
            if (selected == 4) then return end;

            if (selected == 1) then
                TriggerServerEvent("reportSys:server:closeReport",args.data.id)
            elseif (selected == 2 and Config.reportOptions.teleport) then
                TriggerServerEvent("reportSys:server:Teleport", args.data.licence)
            elseif (selected == 3 and Config.reportOptions.teleport) then
                TriggerServerEvent("reportSys:server:DiscSend", args.data.licence)
            end
        end)

        lib.showMenu('menu_reportes_'..args.data.name)
    end)

    lib.showMenu("menu_reportes")
end

function OpenContext(data)
    local input = lib.inputDialog('report', {
        {
            type='select',
            label=TranslateCap("input.select.label"),
            required=true,
            options= Config.typeofreports
        },
        {
            type="textarea",
            label=TranslateCap("input.textarea.label"),
            required=true,
            placeholder=TranslateCap("input.textarea.placeholder"),
            autosize=true
        }
    })

    -- print(json.encode(input, {indent=true}))
    if input then
        data.tipo = input[1]
        data.descripcion = input[2]
        TriggerServerEvent("reportSys:server:newReport", data)
    end
end

RegisterNetEvent("reportSys:client:openReportsMenu", OpenMenu)
RegisterNetEvent("reportSys:client:openReportMenu", OpenContext)