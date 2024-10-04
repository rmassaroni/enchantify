local enchant = {}

local enchant_mapping = {
    a = "ᔑ", b = "ʖ", c = "ᓵ", d = "↸", e = "ᒷ",
    f = "⎓", g = "⊣", h = "⍑", i = "╎", j = "⋮",
    k = "ꖌ", l = "ꖎ", m = "ᒲ", n = "リ", o = "𝙹",
    p = "!¡", q = "ᑑ", r = "∷", s = "ᓭ", t = "ℸ ̣",
    u = "⚍", v = "⍊", w = "∴", x = "̇", y = "/",
    z = "||", [" "] = " ", ["\n"] = "\n"
}

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

    local win_width = vim.api.nvim_win_get_width(0)
    local win_height = vim.api.nvim_win_get_height(0)

    local opts = {
        relative = 'editor',
        width = win_width,
        height = win_height,
        row = 0,
        col = 0,
        style = 'minimal',
        border = 'single'
    }
    local win = vim.api.nvim_open_win(buf, true, opts)

    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })

    vim.api.nvim_buf_set_option(buf, 'buflisted', false)
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    vim.cmd("au BufDelete <buffer> ++nested silent! pclose")
end

function enchant.enchant_current_buffer()
    enchant.display_translation()
end

return enchant

