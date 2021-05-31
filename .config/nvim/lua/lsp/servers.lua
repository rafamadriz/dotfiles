local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits"
    }
}

local function documentHighlight(client, bufnr)
    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec(
            [[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=#464646
      hi LspReferenceText cterm=bold ctermbg=red guibg=#464646
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=#464646
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
            false
        )
    end
end

local function common_on_attach(client, bufnr)
    if as._default(vim.g.neon_lsp_document_highlight) == true then
        documentHighlight(client, bufnr)
    end
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    -- mappings
    as.map("n", "gD", ":lua vim.lsp.buf.declaration()<CR>")
    as.map("n", "gd", ":lua vim.lsp.buf.definition()<CR>")
    as.map("n", "gy", ":lua vim.lsp.buf.type_definition()<CR>")
    as.map("n", "gr", ":Telescope lsp_references<CR>")
    as.map("n", "gh", ":lua vim.lsp.buf.hover()<CR>")
    as.map("n", "gK", ":lua vim.lsp.buf.signature_help()<CR>")
    as.map("n", "gi", ":lua vim.lsp.buf.implementation()<CR>")
    as.map("n", "<leader>lgD", ":lua vim.lsp.buf.declaration()<CR>")
    as.map("n", "<leader>lgd", ":lua vim.lsp.buf.definition()<CR>")
    as.map("n", "<leader>lgy", ":lua vim.lsp.buf.type_definition()<CR>")
    as.map("n", "<leader>lgr", ":Telescope lsp_references<CR>")
    as.map("n", "<leader>lgh", ":lua vim.lsp.buf.hover()<CR>")
    as.map("n", "<leader>lgk", ":lua vim.lsp.buf.signature_help()<CR>")
    as.map("n", "<leader>lgi", ":lua vim.lsp.buf.implementation()<CR>")
    as.map("n", "<leader>la", ":lua require('utils.extra').code_actions()<CR>")
    as.map("n", "<leader>lA", ":lua require('utils.extra').range_code_actions()<CR>")
    as.map("n", "<leader>ld", ":Telescope lsp_document_diagnostics<CR>")
    as.map("n", "<leader>lD", ":Telescope lsp_workspace_diagnostics<CR>")
    as.map("n", "<leader>lr", ":lua vim.lsp.buf.rename()<CR>")
    as.map("n", "<leader>ls", ":Telescope lsp_document_symbols<CR>")
    as.map("n", "<leader>lS", ":Telescope lsp_workspace_symbols<CR>")
    as.map("n", "<leader>lf", ":lua vim.lsp.buf.formatting()<CR>")
    as.map("n", "<leader>lp", ":lua require('utils.extra').PeekDefinition()<CR>")
    as.map(
        "n",
        "<leader>ll",
        ":lua vim.lsp.diagnostic.show_line_diagnostics({border = as._lsp_borders(vim.g.neon_lsp_win_borders)})<CR>"
    )
    as.map(
        "n",
        "<c-p>",
        ":lua vim.lsp.diagnostic.goto_prev({popup_opts = {border = as._lsp_borders(vim.g.neon_lsp_win_borders)}})<CR>"
    )
    as.map(
        "n",
        "<c-n>",
        ":lua vim.lsp.diagnostic.goto_next({popup_opts = {border = as._lsp_borders(vim.g.neon_lsp_win_borders)}})<CR>"
    )
    as.map("n", "<leader>l.s", [[:LspStop <C-R>=<CR>]], {silent = false})

    as.nvim_set_au(
        "InsertLeave,BufWrite,BufEnter",
        "<buffer>",
        "lua vim.lsp.diagnostic.set_loclist({open_loclist = false})"
    )

    local mappings = {
        ["<leader>"] = {
            l = {
                name = "LSP",
                a = {"code action"},
                A = {"range code action"},
                d = {"document diagnostics"},
                D = {"workspace diagnostics"},
                l = {"line diagnostics"},
                i = {"LSP info"},
                f = {"format"},
                r = {"rename"},
                p = {"peek definition"},
                s = {"document symbols"},
                S = {"workspace symbols"},
                g = {name = "go to"},
                gd = "definition",
                gD = "declaration",
                gy = "type definition",
                gr = "references",
                gh = "documentation",
                gk = "signature help",
                gi = "implementation",
                ["."] = {"LSP stop"},
                [".a"] = {"<cmd>LspStop<cr>", "stop all"},
                [".s"] = {"select"}
            }
        },
        ["g"] = {
            ["d"] = "LSP definition",
            ["D"] = "LSP declaration",
            ["K"] = "LSP signature help",
            ["r"] = "LSP references",
            ["y"] = "LSP type definition",
            ["h"] = "LSP documentation",
            ["i"] = "LSP implementation"
        }
    }

    local wk = require("which-key")
    wk.register(mappings)
end

local path = vim.split(package.path, ";")
-- this is the ONLY correct way to setup your path
table.insert(path, "lua/?.lua")
table.insert(path, "lua/?/init.lua")
local lua_settings = {
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
                "run"
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

local function make_config()
    return {
        -- enable snippet support
        capabilities = capabilities,
        -- map buffer local keybindings when the language server attaches
        on_attach = common_on_attach
    }
end

-- lsp-install
local function setup_servers()
    require "lspinstall".setup()

    -- get all installed servers
    local servers = require "lspinstall".installed_servers()

    for _, server in pairs(servers) do
        local config = make_config()

        config.autostart = as._lsp_auto(server)

        -- language specific config
        if server == "typescript" then
            config.filetypes = {
                "javascript",
                "javascriptreact",
                "javascript.jsx",
                "typescript",
                "typescriptreact",
                "typescript.tsx"
            }
        end
        if server == "bash" then
            config.filetypes = {"sh", "zsh"}
        end
        if server == "lua" then
            config.settings = lua_settings
        end
        if server == "cpp" then
            config.filetypes = {"c", "cpp"}
        end

        require "lspconfig"[server].setup(config)
    end
end

setup_servers()

-- npm i -g emmet-ls
local configs = require "lspconfig/configs"
configs.emmet_ls = {
    default_config = {
        autostart = as._lsp_auto("emmet"),
        cmd = {"emmet-ls", "--stdio"},
        filetypes = {"html", "css"},
        root_dir = function()
            return vim.loop.cwd()
        end,
        settings = {}
    }
}
require("lspconfig").emmet_ls.setup {capabilities = capabilities}
