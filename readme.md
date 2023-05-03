# Como funciona:
/getreports --> te abre un menu con todos los reportes que aya disponibles \
/report --> para reportar sobre un bug o algo

## imgs
![image](https://user-images.githubusercontent.com/73949396/235352285-7e36dd68-8f1f-4cff-9e0b-2f6c0f84e5d4.png)
![image](https://user-images.githubusercontent.com/73949396/235352302-549d6dc5-69f5-4e4a-94f0-5b80cd5f010d.png)
![image](https://user-images.githubusercontent.com/73949396/235352310-73a25204-38e1-497a-bf57-af4ffabd7f89.png)
![image](https://user-images.githubusercontent.com/73949396/235352314-c4e2c7f2-57f7-426b-a14a-9c1874ae2940.png)



# configuracion:
puedes configurar que tipos de reportes pueden haber en el config.lua 

```lua
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
```

#Features
[:check:] multiframework support
[] multimenu support
[] screenshot of entity report.

