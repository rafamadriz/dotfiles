require("formatter").setup {
    filetype = {
        lua = { require("formatter.filetypes.lua").stylua },
        rust = { require("formatter.filetypes.rust").rustfmt },
        c = { require("formatter.filetypes.c").clangformat },
        go = { require("formatter.filetypes.go").goimports },
        css = { require("formatter.filetypes.css").prettier },
        html = { require("formatter.filetypes.html").prettier },
        javascript = { require("formatter.filetypes.javascript").prettier },
        javascriptreact = { require("formatter.filetypes.javascriptreact").prettier },
        typescript = { require("formatter.filetypes.typescript").prettier },
        typescriptreact = { require("formatter.filetypes.typescriptreact").prettier },
        json = { require("formatter.filetypes.json").prettier },
        markdown = {
            function()
                return {
                    exe = "prettier",
                    args = {
                        "--stdin-filepath",
                        vim.api.nvim_buf_get_name(0),
                        "--parser markdown",
                    },
                    stdin = true,
                }
            end,
        },
    },
}
