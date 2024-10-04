local enchant = {}

local enchant_mapping = {
    a = "ᔭ", b = "ᔮ", c = "ᔯ", d = "ᔰ", e = "ᔱ",
    f = "ᔲ", g = "ᔳ", h = "ᔴ", i = "ᔵ", j = "ᔶ",
    k = "ᔷ", l = "ᔸ", m = "ᔹ", n = "ᔺ", o = "ᔻ",
    p = "ᔼ", q = "ᔽ", r = "ᔾ", s = "ᔿ", t = "ᕀ",
    u = "ᕁ", v = "ᕂ", w = "ᕃ", x = "ᕄ", y = "ᕅ",
    z = "ᕅ", [" "] = " ", ["\n"] = "\n"
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

