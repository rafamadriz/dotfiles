local lsp = require "lspconfig"
local capabilities = require "lsp.config".capabilities
local common_on_attach = require "lsp.config".common_on_attach
local cmds = require "lsp.config".cmds

-- npm i -g bash-language-server
lsp.bashls.setup {
    cmd = cmds.bash,
    autostart = as._lsp_auto("bash"),
    on_attach = common_on_attach,
    filetypes = {"sh", "zsh"}
}

-- npm i -g pyright
lsp.pyright.setup {
    cmd = cmds.python,
    autostart = as._lsp_auto("python"),
    on_attach = common_on_attach
}

-- npm i -g vscode-json-languageserver
lsp.jsonls.setup {
    cmd = cmds.json,
    autostart = as._lsp_auto("json"),
    on_attach = common_on_attach
}

-- pacman -S clang
lsp.clangd.setup {
    cmd = cmds.clangd,
    autostart = as._lsp_auto("clangd"),
    on_attach = common_on_attach
}

-- npm i -g typescript typescript-language-server
lsp.tsserver.setup {
    cmd = cmds.tsserver,
    autostart = as._lsp_auto("tsserver"),
    on_attach = common_on_attach,
    filetypes = {"javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx"}
}

-- npm i -g vscode-html-languageserver-bin
lsp.html.setup {
    cmd = cmds.html,
    autostart = as._lsp_auto("html"),
    on_attach = common_on_attach,
    capabilities = capabilities
}

-- npm i -g vscode-css-languageserver-bin
lsp.cssls.setup {
    cmd = cmds.css,
    autostart = as._lsp_auto("css"),
    on_attach = common_on_attach
}
lsp.texlab.setup {
    cmd = cmds.texlab,
    on_attach = common_on_attach,
    autostart = as._lsp_auto("latex")
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
lsp.emmet_ls.setup {autostart = as._lsp_auto("emmet")}

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

local path = vim.split(package.path, ";")
-- this is the ONLY correct way to setup your path
table.insert(path, "lua/?.lua")
table.insert(path, "lua/?/init.lua")
lsp.sumneko_lua.setup {
    cmd = {luabin, "-E", luapath .. "/main.lua"},
    autostart = as._lsp_auto("lua"),
    on_attach = common_on_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Setup your lua path
                path = path
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {
                    "vim",
                    "as",
                    "DATA_PATH",
                    "use",
                    "run",
                    "Theming",
                    "LSP",
                    "Completion",
                    "Opts",
                    "Formatting",
                    "Treesitter"
                }
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
                },
                maxPreload = 10000,
                preloadFileSize = 50000
            },
            telemetry = {
                enable = false
            }
        }
    }
}
