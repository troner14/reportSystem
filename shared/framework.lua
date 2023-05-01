Config.framework = nil
Config.frameworkVersion = nil

if (GetResourceState("es_extended") == "started" or GetResourceState("es_extended") == "starting") then
    local fxmanifest = LoadResourceFile("es_extended", "fxmanifest.lua")
    local version = fxmanifest:match("version%s+'([%d%.]+)'")
    print((version > "1.2.0" or version > "1.2"))
    if (version > "1.2.0" or version > "1.2") then
        Config.frameworkVersion = "legacy"
    else
        Config.frameworkVersion = "1.2"
    end
    Config.framework = "ESX"
    ESX = exports['es_extended']:getSharedObject()
    loadModule("shared/framework/esx/main.lua")
end

if (GetResourceState("qb-core") == "started" or GetResourceState("qb-core") == "starting") then
    Config.framework = "QB"
    QBCore = exports['qb-core']:GetCoreObject()
    loadModule("shared/framework/qb/main.lua")
end