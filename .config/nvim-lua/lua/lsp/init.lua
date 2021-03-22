local on_attach = require'completion'.on_attach
-- npm i -g bash-language-server
require'lspconfig'.bashls.setup{ on_attach=on_attach }

-- npm i -g typescript typescript-language-server
require'lspconfig'.tsserver.setup{ on_attach = on_attach }

-- npm i -g vscode-css-languageserver-bin
require'lspconfig'.cssls.setup{}

-- npm i -g vscode-html-languageserver-bin
require'lspconfig'.html.setup{}

-- npm i -g pyright
require'lspconfig'.pyright.setup{}

-- npm i -g vscode-json-languageserver
require'lspconfig'.jsonls.setup {
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
        end
      }
    }
}
