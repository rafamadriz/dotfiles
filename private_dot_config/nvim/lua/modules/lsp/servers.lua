if not as._default(vim.g.code_lsp_enabled) then
    return
end

local function common_on_attach(client, bufnr)
    if as._default(vim.g.code_lsp_document_highlight) then
        require("modules.lsp").documentHighlight(client, bufnr)
    end
    require("lsp_signature").on_attach { max_width = 90, fix_pos = true, hint_prefix = " " }
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
    as.map("n", "<leader>lc", ":lua vim.diagnostic.hide()<CR>")
    as.map("n", "<leader>lA", ":Telescope lsp_range_code_actions<CR>")
    as.map("n", "<leader>ld", ":Telescope diagnostics bufnr=0<CR>")
    as.map("n", "<leader>lD", ":Telescope diagnostics<CR>")
    as.map("n", "<leader>lr", ":lua vim.lsp.buf.rename()<CR>")
    as.map("n", "<leader>ls", ":Telescope lsp_document_symbols<CR>")
    as.map("n", "<leader>lS", ":Telescope lsp_workspace_symbols<CR>")
    as.map("n", "<leader>lf", ":lua vim.lsp.buf.formatting()<CR>")
    as.map("n", "<leader>lp", ":lua require('modules.lsp').PeekDefinition()<CR>")
    as.map(
        "n",
        "<leader>ll",
        ":lua vim.diagnostic.open_float(0, {border = as._lsp_borders(vim.g.code_lsp_window_borders)})<CR>"
    )
    as.map(
        "n",
        "<c-p>",
        ":lua vim.diagnostic.goto_prev({float = {border = as._lsp_borders(vim.g.code_lsp_window_borders)}})<CR>"
    )
    as.map(
        "n",
        "<c-n>",
        ":lua vim.diagnostic.goto_next({float = {border = as._lsp_borders(vim.g.code_lsp_window_borders)}})<CR>"
    )
    as.map("n", "<leader>l,s", [[:LspStop <C-R>=<CR>]], { silent = false })

    as.nvim_set_au(
        "InsertLeave,BufWrite,BufEnter",
        "<buffer>",
        "lua vim.diagnostic.setloclist({open = false})"
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

require("nvim-lsp-installer").on_server_ready(function(server)
    local opts = {
        -- enable snippet support
        capabilities = require("modules.lsp").capabilities,
        -- map buffer local keybindings when the language server attaches
        on_attach = common_on_attach,
        flags = { debounce_text_changes = 150 },
        autostart = as._lsp_auto(server.name),
    }

    -- language specific config
    if server.name == "bashls" then
        opts.filetypes = { "sh", "zsh" }
    end
    if server.name == "sumneko_lua" then
        opts.settings = {
            Lua = {
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
                    maxPreload = 10000,
                    preloadFileSize = 50000,
                },
            },
        }
    end

    server:setup(opts)
    vim.cmd [[ do User LspAttachBuffers ]]
end)
