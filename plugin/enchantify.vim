if exists("g:loaded_enchantify")
    finish
endif
let g:loaded_enchantify = 1

command! Enchantify call luaeval("require('enchantify').enchant_current_buffer()")
