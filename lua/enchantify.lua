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

local get_usable_window_width = function()
    local window_width = vim.api.nvim_exec(
    [[
      function! BufferWidth()
        let width = winwidth(0)
        let numberwidth = max([&numberwidth, strlen(line('$')) + 1])
        let numwidth = (&number || &relativenumber) ? numberwidth : 0
        let foldwidth = &foldcolumn

        if &signcolumn == 'yes'
          let signwidth = 2
        elseif &signcolumn =~ 'yes'
          let signwidth = &signcolumn
          let signwidth = split(signwidth, ':')[1]
          let signwidth *= 2
        elseif &signcolumn == 'auto'
          let supports_sign_groups = has('nvim-0.4.2') || has('patch-8.1.614')
          let signlist = execute(printf('sign place ' . (supports_sign_groups ? 'group=* ' : '') . 'buffer=%d', bufnr('')))
          let signlist = split(signlist, "\n")
          let signwidth = len(signlist) > 2 ? 2 : 0
        elseif &signcolumn =~ 'auto'
          let signwidth = 0
          if len(sign_getplaced(bufnr(),{'group':'*'})[0].signs)
            let signwidth = 0
            for l:sign in sign_getplaced(bufnr(),{'group':'*'})[0].signs
              let lnum = l:sign.lnum
              let signs = len(sign_getplaced(bufnr(),{'group':'*', 'lnum':lnum})[0].signs)
              let signwidth = (signs > signwidth ? signs : signwidth)
            endfor
          endif
          let signwidth *= 2
        else
          let signwidth = 0
        endif

        return width - numwidth - foldwidth - signwidth
      endfunction
      echo BufferWidth()
    ]],
    true
    )
    return tonumber(window_width)
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

    local win_width = get_usable_window_width()
    local win_height = #lines

    local opts = {
        relative = 'editor',
        width = win_width,
        height = win_height,
        row = 0,
        col = 0,
        border = 'none'
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
