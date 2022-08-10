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
        markdown = { require("formatter.filetypes.markdown").prettier },
    },
}
