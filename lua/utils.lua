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

return get_usable_window_width
