local lsp_config = {}
DATA_PATH = vim.fn.stdpath("data")
local lspinstall = DATA_PATH .. "/lspinstall/"
local u = require("utils.core")

lsp_config.capabilities = vim.lsp.protocol.make_client_capabilities()
lsp_config.capabilities.textDocument.completion.completionItem.snippetSupport = true
lsp_config.capabilities.textDocument.completion.completionItem.resolveSupport = {
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

function lsp_config.common_on_attach(client, bufnr)
    if LSP.highlight_word == nil or LSP.highlight_word == true then
        documentHighlight(client, bufnr)
    end

    -- mappings
    u.map("n", "gD", ":lua vim.lsp.buf.declaration()<CR>")
    u.map("n", "gd", ":lua vim.lsp.buf.definition()<CR>")
    u.map("n", "gy", ":lua vim.lsp.buf.type_definition()<CR>")
    u.map("n", "gr", ":Telescope lsp_references<CR>")
    u.map("n", "gh", ":lua vim.lsp.buf.hover()<CR>")
    u.map("n", "gK", ":lua vim.lsp.buf.signature_help()<CR>")
    u.map("n", "gi", ":lua vim.lsp.buf.implementation()<CR>")
    u.map("n", "<leader>la", ":lua require('utils.core').code_actions()<CR>")
    u.map("n", "<leader>lA", ":lua require('utils.core').range_code_actions()<CR>")
    u.map("n", "<leader>ld", ":Telescope lsp_document_diagnostics<CR>")
    u.map("n", "<leader>lD", ":Telescope lsp_workspace_diagnostics<CR>")
    u.map("n", "<leader>ll", ":lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
    u.map("n", "<leader>li", ":LspInfo<cr>")
    u.map("n", "<leader>lr", ":lua vim.lsp.buf.rename()<CR>")
    u.map("n", "<leader>ls", ":Telescope lsp_document_symbols<CR>")
    u.map("n", "<leader>lS", ":Telescope lsp_workspace_symbols<CR>")
    u.map("n", "<leader>lf", ":lua vim.lsp.buf.formatting()<CR>")
    u.map("n", "<c-p>", ":lua vim.lsp.diagnostic.goto_prev()<CR>")
    u.map("n", "<c-n>", ":lua vim.lsp.diagnostic.goto_next()<CR>")
    -- Lsp Stop
    u.map("n", "<leader>l.s", [[:LspStop <C-R>=<CR>]], {silent = false})

    local opts = {
        mode = "n", -- NORMAL mode
        buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
        silent = true, -- use `silent` when creating keymaps
        noremap = true, -- use `noremap` when creating keymaps
        nowait = false -- use `nowait` when creating keymaps
    }

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
                s = {"document symbols"},
                S = {"workspace symbols"},
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
    wk.register(mappings, opts)
end

-- LSP commands
-- ==================================================
lsp_config.cmds = {
    bash = {lspinstall .. "bash/node_modules/.bin/bash-language-server", "start"},
    css = {
        "node",
        lspinstall .. "css/vscode-css/css-language-features/server/dist/node/cssServerMain.js",
        "--stdio"
    },
    clangd = {lspinstall .. "cpp/clangd/bin/clangd"},
    html = {
        "node",
        lspinstall .. "html/vscode-html/html-language-features/server/dist/node/htmlServerMain.js",
        "--stdio"
    },
    json = {
        "node",
        lspinstall .. "json/vscode-json/json-language-features/server/dist/node/jsonServerMain.js",
        "--stdio"
    },
    python = {lspinstall .. "python/node_modules/.bin/pyright-langserver", "--stdio"},
    texlab = {lspinstall .. "latex/texlab"},
    tsserver = {lspinstall .. "typescript/node_modules/.bin/typescript-language-server", "--stdio"}
}

-- Add LSP colors to colorschemes that don't support it yet
-- Taken from https://github.com/folke/lsp-colors.nvim
-- =========================================================
local defaults = {
    Error = "#db4b4b",
    Warning = "#e0af68",
    Information = "#0db9d7",
    Hint = "#10B981"
}

local config = {}

function lsp_config.hl(name)
    return vim.api.nvim_get_hl_by_name(name, true)
end

function lsp_config.exists(name)
    if vim.fn.hlexists(name) == 1 then
        local hl = lsp_config.hl(name)
        local count = 0
        for key, value in pairs(hl) do
            -- this is needed for groups that only have "cleared"
            if not (key == true and value == 6) then
                count = count + 1
            end
        end
        return count > 0
    end
    return false
end

function lsp_config.link(group, fallbacks, default)
    if not lsp_config.exists(group) then
        for _, fallback in pairs(fallbacks) do
            if lsp_config.exists(fallback) then
                vim.cmd("hi link " .. group .. " " .. fallback)
                return
            end
        end
        if default then
            vim.cmd("hi " .. group .. " " .. default)
        end
    end
end

function lsp_config.fix()
    -- dump({ fix = event })
    -- Default Groups
    for _, lsp in pairs({"Error", "Warning", "Information", "Hint"}) do
        local coc = lsp
        if lsp == "Information" then
            coc = "Info"
        end
        lsp_config.link("LspDiagnosticsDefault" .. lsp, {"Coc" .. coc .. "Sign"}, "guifg=" .. config[lsp])
        lsp_config.link("LspDiagnosticsVirtualText" .. lsp, {"LspDiagnosticsDefault" .. lsp})

        local color = defaults[lsp]
        local hl = lsp_config.hl("LspDiagnosticsDefault" .. lsp)
        if hl and hl.foreground then
            color = string.format("#%06x", hl.foreground)
        end
        lsp_config.link("LspDiagnosticsUnderline" .. lsp, {}, "gui=undercurl guisp=" .. color)
    end

    lsp_config.link("LspReferenceText", {"CocHighlightText", "CursorLine"})
    lsp_config.link("LspReferenceRead", {"CocHighlightRead", "LspReferenceText"})
    lsp_config.link("LspReferenceWrite", {"CocHighlightWrite", "LspReferenceText"})
end

function lsp_config.setup(options)
    config = vim.tbl_deep_extend("force", {}, defaults, options or {})
end

lsp_config.setup()

return lsp_config
