-- lua  https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)
-- install instructions:
-- git clone https://github.com/sumneko/lua-language-server $HOME/.cache/nvim/nlua/sumneko_lua
-- cd ~/.cache/nvim/nlua/sumneko_lua
-- git submodule update --init --recursive
-- cd 3rd/luamake
-- ninja -f ninja/linux.ninja
-- cd ../..
-- ./3rd/luamake/luamake rebuild
local sumneko_root_path = '/home/rafa/.cache/nvim/nlua/sumneko_lua'
local sumneko_binary = sumneko_root_path..'/bin/Linux/lua-language-server'

require'lspconfig'.sumneko_lua.setup {
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
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
}
require'lspconfig'.sumneko_lua.setup{ on_attach = on_attach }
