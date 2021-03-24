local on_attach = require'utils'.commom_on_attach

-- npm i -g bash-language-server
require'lspconfig'.bashls.setup{ on_attach = on_attach }

-- npm i -g typescript typescript-language-server
require'lspconfig'.tsserver.setup{ on_attach = on_attach }

-- npm i -g vscode-css-languageserver-bin
require'lspconfig'.cssls.setup{ on_attach = on_attach }

-- npm i -g vscode-html-languageserver-bin
require'lspconfig'.html.setup{ on_attach = on_attach }

-- npm i -g pyright
require'lspconfig'.pyright.setup{ on_attach = on_attach }

-- npm i -g vscode-json-languageserver
require'lspconfig'.jsonls.setup { on_attach = on_attach }

-- lua  https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)
-- install instructions:
-- git clone https://github.com/sumneko/lua-language-server $HOME/.cache/nvim/nlua/sumneko_lua
-- cd ~/.cache/nvim/nlua/sumneko_lua
-- git submodule update --init --recursive
-- cd 3rd/luamake
-- ninja -f ninja/linux.ninja
-- cd ../..
-- ./3rd/luamake/luamake rebuild
local luapath = '/home/rafa/.cache/nvim/nlua/sumneko_lua'
local luabin = luapath..'/bin/Linux/lua-language-server'

require'lspconfig'.sumneko_lua.setup {
  cmd = {luabin, "-E", luapath .. "/main.lua"};
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';'),
      },
      completion = { enable = true },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {"vim", "map", "filter", "range", "reduce", "head", "tail", "nth", "use"},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
    },
  },
  on_attach = on_attach
}
