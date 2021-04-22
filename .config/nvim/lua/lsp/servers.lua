local nvim_lsp = require "lspconfig"
local capabilities = require "utils.lsp".capabilities
local common_on_attach = require "utils.lsp".common_on_attach
local cmds = require "utils.lsp".cmds

-- npm i -g bash-language-server
nvim_lsp.bashls.setup {
    cmd = cmds.bash,
    autostart = LSP.bash,
    on_attach = common_on_attach,
    filetypes = {"sh", "zsh"}
}

-- npm i -g pyright
nvim_lsp.pyright.setup {
    cmd = cmds.python,
    autostart = LSP.python,
    on_attach = common_on_attach
}

-- npm i -g vscode-json-languageserver
nvim_lsp.jsonls.setup {
    cmd = cmds.python,
    autostart = LSP.json,
    on_attach = common_on_attach
}

-- pacman -S clang
nvim_lsp.clangd.setup {
    cmd = cmds.clangd,
    autostart = LSP.clangd,
    on_attach = common_on_attach
}

-- npm i -g typescript typescript-language-server
nvim_lsp.tsserver.setup {
    cmd = cmds.tsserver,
    autostart = LSP.tsserver,
    on_attach = common_on_attach,
    filetypes = {"javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx"}
}

-- npm i -g vscode-html-languageserver-bin
nvim_lsp.html.setup {
    cmd = cmds.html,
    autostart = LSP.html,
    on_attach = common_on_attach,
    capabilities = capabilities
}

-- npm i -g vscode-css-languageserver-bin
nvim_lsp.cssls.setup {
    cmd = cmds.css,
    autostart = LSP.css,
    on_attach = common_on_attach
}

nvim_lsp.texlab.setup {
    cmd = cmds.texlab,
    on_attach = common_on_attach,
    autostart = LSP.latex
}

-- npm i -g emmet-ls
local configs = require "lspconfig/configs"
configs.emmet_ls = {
    default_config = {
        cmd = {"emmet-ls", "--stdio"},
        filetypes = {"html", "css"},
        root_dir = function()
            return vim.loop.cwd()
        end,
        settings = {}
    }
}
nvim_lsp.emmet_ls.setup {autostart = LSP.emmet}

-- lua  https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)
-- install instructions:
-- git clone https://github.com/sumneko/lua-language-server $HOME/.local/share/nvim/lua/sumneko_lua
-- cd ~/.local/share/nvim/lua/sumneko_lua
-- git submodule update --init --recursive
-- cd 3rd/luamake
-- ninja -f ninja/linux.ninja
-- cd ../..
-- ./3rd/luamake/luamake rebuild

local luapath = vim.fn.stdpath("data") .. "/lspinstall/lua"
local luabin = luapath .. "/sumneko-lua-language-server"

nvim_lsp.sumneko_lua.setup {
    cmd = {luabin, "-E", luapath .. "/main.lua"},
    autostart = LSP.lua,
    on_attach = common_on_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Setup your lua path
                path = vim.split(package.path, ";")
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {"vim", "use", "run", "Theming", "LSP", "Completion", "Formatting", "Treesitter"}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
                },
                maxPreload = 10000
            },
            telemetry = {
                enable = false
            }
        }
    }
}
