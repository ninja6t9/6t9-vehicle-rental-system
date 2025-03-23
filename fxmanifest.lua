fx_version 'cerulean'
game 'gta5'

author 'ninja 6t9'
description 'Custom Vehicle Rental System'
version '1.0'

shared_script 'config.lua'

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua', -- Change to your database type if needed
    'server.lua'
}
