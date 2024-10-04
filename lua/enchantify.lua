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

function enchant.enchant_current_buffer()
    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    for i, line in ipairs(lines) do
        lines[i] = enchant.translate_to_enchant(line)
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

return enchant

