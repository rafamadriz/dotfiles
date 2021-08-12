if not as._default(vim.g.code_lsp_enabled) then
    return
end

local function common_on_attach(client, bufnr)
    if as._default(vim.g.code_lsp_document_highlight) then
        require("modules.lsp").documentHighlight(client, bufnr)
    end
    if as._default(vim.g.code_lsp_signature_help) then
        require("lsp_signature").on_attach { max_width = 90, fix_pos = true, hint_prefix = " " }
    end
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    -- mappings
    as.map("n", "gd", ":lua vim.lsp.buf.definition()<CR>")
    as.map("n", "gD", ":lua vim.lsp.buf.declaration()<CR>")
    as.map("n", "gy", ":lua vim.lsp.buf.type_definition()<CR>")
    as.map("n", "gr", ":Telescope lsp_references<CR>")
    as.map("n", "gh", ":lua vim.lsp.buf.hover()<CR>")
    as.map("n", "K", ":lua vim.lsp.buf.signature_help()<CR>")
    as.map("n", "gi", ":lua vim.lsp.buf.implementation()<CR>")
    as.map("n", "<leader>lgD", ":lua vim.lsp.buf.declaration()<CR>")
    as.map("n", "<leader>lgd", ":lua vim.lsp.buf.definition()<CR>")
    as.map("n", "<leader>lgy", ":lua vim.lsp.buf.type_definition()<CR>")
    as.map("n", "<leader>lgr", ":Telescope lsp_references<CR>")
    as.map("n", "<leader>lgi", ":lua vim.lsp.buf.implementation()<CR>")
    as.map("n", "<leader>lh", ":lua vim.lsp.buf.hover()<CR>")
    as.map("n", "<leader>lk", ":lua vim.lsp.buf.signature_help()<CR>")
    as.map("n", "<leader>la", ":Telescope lsp_code_actions<CR>")
    as.map("n", "<leader>lc", ":lua vim.lsp.diagnostic.clear(0)<CR>")
    as.map("n", "<leader>lA", ":Telescope lsp_range_code_actions<CR>")
    as.map("n", "<leader>ld", ":Telescope lsp_document_diagnostics<CR>")
    as.map("n", "<leader>lD", ":Telescope lsp_workspace_diagnostics<CR>")
    as.map("n", "<leader>lr", ":lua vim.lsp.buf.rename()<CR>")
    as.map("n", "<leader>ls", ":Telescope lsp_document_symbols<CR>")
    as.map("n", "<leader>lS", ":Telescope lsp_workspace_symbols<CR>")
    as.map("n", "<leader>lf", ":lua vim.lsp.buf.formatting()<CR>")
    as.map("n", "<leader>lp", ":lua require('modules.lsp').PeekDefinition()<CR>")
    as.map(
        "n",
        "<leader>ll",
        ":lua vim.lsp.diagnostic.show_line_diagnostics({border = as._lsp_borders(vim.g.code_lsp_window_borders)})<CR>"
    )
    as.map(
        "n",
        "<c-p>",
        ":lua vim.lsp.diagnostic.goto_prev({popup_opts = {border = as._lsp_borders(vim.g.code_lsp_window_borders)}})<CR>"
    )
    as.map(
        "n",
        "<c-n>",
        ":lua vim.lsp.diagnostic.goto_next({popup_opts = {border = as._lsp_borders(vim.g.code_lsp_window_borders)}})<CR>"
    )
    as.map("n", "<leader>l,s", [[:LspStop <C-R>=<CR>]], { silent = false })

    as.nvim_set_au(
        "InsertLeave,BufWrite,BufEnter",
        "<buffer>",
        "lua vim.lsp.diagnostic.set_loclist({open_loclist = false})"
    )

    local mappings = {
        ["<leader>"] = {
            l = {
                name = "LSP",
                [","] = { "LSP stop" },
                [",a"] = { "<cmd>LspStop<cr>", "stop all" },
                [",s"] = { "select" },
                A = "code actions (range)",
                D = "diagnostics (project)",
                S = "symbols (project)",
                a = "code actions (cursor)",
                c = "clear diagnostics",
                d = "diagnostics (buffer)",
                f = "format",
                g = { name = "go to" },
                gD = "declaration",
                gd = "definition",
                gi = "implementation",
                gr = "references",
                gy = "type definition",
                h = "hover",
                i = "LSP info",
                k = "signature help",
                l = "line diagnostics",
                p = "peek definition",
                r = "rename",
                s = "symbols (buffer)",
            },
        },
        ["g"] = {
            ["D"] = "LSP declaration",
            ["d"] = "LSP definition",
            ["h"] = "LSP documentation",
            ["i"] = "LSP implementation",
            ["r"] = "LSP references",
            ["y"] = "LSP type definition",
        },
    }

    local wk = require "which-key"
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
            path = path,
        },
        diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {
                "vim",
                "as",
                "DATA_PATH",
                "use",
                "run",
            },
        },
        workspace = {
            -- Make the server aware of Neovim runtime files
            library = {
                [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
            },
            maxPreload = 10000,
            preloadFileSize = 50000,
        },
        telemetry = {
            enable = false,
        },
    },
}

local function make_config()
    return {
        -- enable snippet support
        capabilities = require("modules.lsp").capabilities,
        -- map buffer local keybindings when the language server attaches
        on_attach = common_on_attach,
        flags = { debounce_text_changes = 150 },
    }
end

-- lsp-install
local function setup_servers()
    require("lspinstall").setup()

    -- get all installed servers
    local servers = require("lspinstall").installed_servers()

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
                "typescript.tsx",
            }
        end
        if server == "bash" then
            config.filetypes = { "sh", "zsh" }
        end
        if server == "lua" then
            config.settings = lua_settings
        end
        if server == "cpp" then
            config.filetypes = { "c", "cpp" }
        end

        require("lspconfig")[server].setup(config)
    end
end

setup_servers()

-- npm i -g emmet-ls
local lspconfig = require "lspconfig"
local configs = require "lspconfig/configs"
if not lspconfig.emmet_ls then
    configs.emmet_ls = {
        default_config = {
            autostart = as._lsp_auto "emmet",
            cmd = { "emmet-ls", "--stdio" },
            filetypes = { "html", "css" },
            root_dir = function()
                return vim.loop.cwd()
            end,
            settings = {},
        },
    }
end
lspconfig.emmet_ls.setup { capabilities = require("modules.lsp").capabilities }

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require("lspinstall").post_install_hook = function()
    setup_servers() -- reload installed servers
    vim.cmd "bufdo e"
end
