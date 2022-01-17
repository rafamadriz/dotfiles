local M = {}

local function fmt(args)
    return function()
        return args
    end
end

M.prettier = function(opts)
    return fmt {
        exe = "prettier",
        args = vim.tbl_flatten { "--stdin-filepath", vim.api.nvim_buf_get_name(0), opts or {} },
        stdin = true,
    }
end

-- npm install -g @fsouza/prettierd
-- run `prettierd start`
M.prettierd = fmt {
    exe = "prettierd",
    args = { vim.api.nvim_buf_get_name(0) },
    stdin = true,
}

M.clang = fmt {
    exe = "clang-format",
    args = {
        "-assume-filename=" .. vim.fn.expand "%:t",
        [[
        -style='{IndentWidth: 4,
        AlignConsecutiveAssignments: true,
        AllowShortBlocksOnASingleLine: Empty,
        AllowShortLoopsOnASingleLine: true,
        AllowShortIfStatementsOnASingleLine: true,
        AlignConsecutiveMacros: true,
        BreakBeforeBraces: Linux,
        AlignConsecutiveDeclarations: true,
        AlwaysBreakAfterReturnType: None}'
        ]],
    },
    stdin = true,
}

M.stylua = fmt {
    exe = "stylua",
    args = { "--search-parent-directories", "--stdin-filepath", '"%:p"', "--", "-" },
    stdin = true,
}

M.sh = fmt {
    exe = "shfmt",
    args = { "-i " .. vim.opt.shiftwidth:get() },
    stdin = true,
}

M.black = fmt {
    exe = "black",
    args = { "--quiet", "-" },
    stdin = true,
}

M.goimports = fmt {
    exe = "goimports",
    stdin = true,
}

M.rustfmt = fmt {
    exe = "rustfmt",
    args = {
        string.format(
            "--config hard_tabs=%s,tab_spaces=%s",
            not vim.opt.expandtab:get(),
            vim.opt.shiftwidth:get()
        ),
    },
    stdin = true,
}

M.latex = fmt {
    exe = "latexindent",
    args = { "-g /dev/stderr", "2>/dev/null" },
    stdin = true,
}

M.config = function()
    require("formatter").setup {
        logging = false,
        filetype = {
            sh = { M.sh },
            zsh = { M.sh },
            c = { M.clang },
            cs = { M.clang },
            cpp = { M.clang },
            lua = { M.stylua },
            tex = { M.latex },
            python = { M.black },
            go = { M.goimports },
            rust = { M.rustfmt },
            css = { M.prettier "--parser css" },
            xml = { M.prettier() },
            json = { M.prettier() },
            html = { M.prettier "--parser html" },
            scss = { M.prettier() },
            markdown = { M.prettier() },
            javascript = { M.prettier { "--single-quote --parser typescript" } },
            typescript = { M.prettier { "--single-quote" } },
            javascriptreact = { M.prettier { "--single-quote" } },
            typescriptreact = { M.prettier { "--single-quote" } },
        },
    }
end

return M
