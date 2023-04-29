fx_version "cerulean"
game "gta5"

author "Troner14"
description "A simple report system with ox_lib."
repository "https://github.com/iLLeniumStudios/illenium-appearance"
version "v1.0"
lua54 "yes"

client_scripts {
    "client/*.lua"
}

server_scripts {
  "@oxmysql/lib/MySQL.lua",
  "server/*.lua"
}

shared_scripts {
  "config.lua",
  "@ox_lib/init.lua",
  "@es_extended/imports.lua",
  '@es_extended/locale.lua',
  "locales/*.lua",
}

dependency {
  "oxmysql",
  "ox_lib",
  "es_extended"
}