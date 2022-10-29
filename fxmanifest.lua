fx_version 'cerulean'
game 'gta5'

author 'Nema#0001'
description 'nema pickupbike'
version '1.0.0'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_script {
    'client/*.lua'
}

escrow_ignore {
    'config.lua',
    'client/*.lua',
    'fxmanifest'
  }