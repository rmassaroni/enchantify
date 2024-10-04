local enchant_mapping = require("mapping")
local get_usable_window_width = require("utils")

local enchant = {}

function enchant.translate_to_enchant(text)
    local translated = text:gsub(".", function(char)
        return enchant_mapping[char] or char
    end)
    return translated
end

function enchant.display_translation()
    local current_buf = vim.api.nvim_get_current_buf()
    local buf = vim.api.nvim_create_buf(false, true)

    local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)

    local translated_lines = {}
    for _, line in ipairs(lines) do
        table.insert(translated_lines, enchant.translate_to_enchant(line))
    end

    local status_line = "Translated with Enchantify. Press 'q' to close."
    table.insert(translated_lines, status_line)

    -- vim.api.nvim_buf_set_lines(buf, 0, -1, false, translated_lines)
    -- vim.api.nvim_buf_set_lines(buf, -1, -1, false, { status_line })
    --
    -- vim.api.nvim_buf_set_option(buf, 'number', true)
    -- vim.api.nvim_buf_set_option(buf, 'relativenumber', true)
    --
    -- local win_width = get_usable_window_width()
    -- local win_height = #translated_lines + 1

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, translated_lines)

    vim.api.nvim_buf_set_option(buf, 'number', true)
    vim.api.nvim_buf_set_option(buf, 'relativenumber', true)

    local win_width = get_usable_window_width()
    -- local win_height = #lines + 1
    local win_height = #translated_lines

    local opts = {
        relative = 'editor',
        width = win_width,
        height = win_height,
        row = 0,
        col = 0,
        border = 'none'
    }
    local win = vim.api.nvim_open_win(buf, true, opts)

    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'buflisted', false)

    -- vim.api.nvim_buf_set_option(buf, 'modifiable', true)
    --
    -- vim.api.nvim_buf_set_lines(buf, 0, -1, false, translated_lines)
    --
    -- local status_line = "Translated with Enchantify. Press 'q' to close."
    -- vim.api.nvim_buf_set_lines(buf, -1, -1, false, { status_line })

    vim.api.nvim_buf_set_option(buf, 'modifiable', false)

    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })

    -- vim.api.nvim_buf_set_option(buf, 'buflisted', false)
    -- vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    vim.cmd("au BufDelete <buffer> ++nested silent! pclose")
end

function enchant.enchant_current_buffer()
    enchant.display_translation()
end

return enchant
