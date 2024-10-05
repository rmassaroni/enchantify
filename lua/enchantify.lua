local enchant_mapping = require("mapping")

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

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, translated_lines)

    vim.api.nvim_buf_set_option(buf, 'number', true)
    vim.api.nvim_buf_set_option(buf, 'relativenumber', true)
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)

    local filetype = vim.api.nvim_buf_get_option(current_buf, 'filetype')
    vim.api.nvim_buf_set_option(buf, 'filetype', filetype)

    local signs = vim.fn.sign_getplaced(current_buf, {group = '*'})
    if #signs > 0 then
        local placed_signs = signs[1].signs
        for _, sign in ipairs(placed_signs) do
            -- local sign_def = vim.fn.sign_getdefined(sign.name)
            vim.fn.sign_define(sign.name, {text = '>>', texthl = 'WarningMsg'})
            vim.fn.sign_place(0, sign.group, sign.name, buf, {lnum = sign.lnum, priority = sign.priority})
            -- if sign_def and #sign_def > 0 then
            --     vim.fn.sign_define(sign.name, {
            --         text = sign_def[1].text,
            --         texthl = sign_def[1].texthl,
            --         numhl = sign_def[1].numhl,
            --         linehl = sign_def[1].linehl,
            --         icon = sign_def[1].icon
            --     })
            --
            --     vim.fn.sign_place(0, sign.group, sign.name, buf, {lnum = sign.lnum, priority = sign.priority})
            -- end
        end
    end

    local win_width = vim.fn.winwidth(0)
    local win_height = vim.fn.winheight(0)
    local win_height_adjusted = math.min(win_height, #translated_lines)

    local opts = {
        relative = 'editor',
        width = win_width,
        height = win_height_adjusted,
        row = 0,
        col = 0,
        border = 'none'
    }

    local win = vim.api.nvim_open_win(buf, true, opts)

    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })

    vim.cmd("au BufDelete <buffer> ++nested silent! pclose")
end

function enchant.enchant_current_buffer()
    enchant.display_translation()
end

return enchant
