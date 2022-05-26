fx_version 'adamant'
game 'gta5'

author 'Enzo2991 '
title 'kls_sims'
description 'Script which aims to generate a sim card for gksphone'
version '1.0.0'

shared_scripts {
    'config.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
}

client_scripts {
    'src/RageUI/RMenu.lua',
    'src/RageUI/menu/RageUI.lua',
    'src/RageUI/menu/Menu.lua',
    'src/RageUI/menu/MenuController.lua',
    'src/RageUI/components/*.lua',
    'src/RageUI/menu/elements/*.lua',
    'src/RageUI/menu/items/*.lua',
    'src/RageUI/menu/panels/*.lua',
    'src/RageUI/menu/windows/*.lua',
}

client_scripts {
	'client/menu.lua',
	'client/function.lua',
}

server_scripts {
    'server/function.lua',
    'server/command.lua',
}