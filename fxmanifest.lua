fx_version "cerulean"
game "gta5"

author "Troner14"
description "A simple report system with ox_lib."
version "v1.4"
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
  'shared/locales.lua',
  "locales/*.lua",
}

files {
  "shared/**/*.lua"
}

dependency {
  "oxmysql",
  "ox_lib",
}
