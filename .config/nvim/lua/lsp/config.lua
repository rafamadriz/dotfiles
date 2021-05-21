local M = {}
local cmd_path = DATA_PATH .. "/lspinstall/"
M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities.textDocument.completion.completionItem.resolveSupport = {
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

function M.common_on_attach(client, bufnr)
    if LSP.highlight_word == nil or LSP.highlight_word == true then
        documentHighlight(client, bufnr)
    end

    local map = as.map
    -- mappings
    map("n", "gD", ":lua vim.lsp.buf.declaration()<CR>")
    map("n", "gd", ":lua vim.lsp.buf.definition()<CR>")
    map("n", "gy", ":lua vim.lsp.buf.type_definition()<CR>")
    map("n", "gr", ":Telescope lsp_references<CR>")
    map("n", "gh", ":lua vim.lsp.buf.hover()<CR>")
    map("n", "gK", ":lua vim.lsp.buf.signature_help()<CR>")
    map("n", "gi", ":lua vim.lsp.buf.implementation()<CR>")
    map("n", "<leader>la", ":lua as.code_actions()<CR>")
    map("n", "<leader>lA", ":lua as.range_code_actions()<CR>")
    map("n", "<leader>ld", ":Telescope lsp_document_diagnostics<CR>")
    map("n", "<leader>lD", ":Telescope lsp_workspace_diagnostics<CR>")
    map("n", "<leader>ll", ":lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
    map("n", "<leader>li", ":LspInfo<cr>")
    map("n", "<leader>lr", ":lua vim.lsp.buf.rename()<CR>")
    map("n", "<leader>ls", ":Telescope lsp_document_symbols<CR>")
    map("n", "<leader>lS", ":Telescope lsp_workspace_symbols<CR>")
    map("n", "<leader>lf", ":lua vim.lsp.buf.formatting()<CR>")
    map("n", "<leader>lp", ":lua as.PeekDefinition()<CR>")
    map("n", "<c-p>", ":lua vim.lsp.diagnostic.goto_prev()<CR>")
    map("n", "<c-n>", ":lua vim.lsp.diagnostic.goto_next()<CR>")
    -- Lsp Stop
    map("n", "<leader>l.s", [[:LspStop <C-R>=<CR>]], {silent = false})

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

-- LSP commands
-- ==================================================
M.cmds = {
    bash = {cmd_path .. "bash/node_modules/.bin/bash-language-server", "start"},
    css = {
        "node",
        cmd_path .. "css/vscode-css/css-language-features/server/dist/node/cssServerMain.js",
        "--stdio"
    },
    clangd = {cmd_path .. "cpp/clangd/bin/clangd"},
    html = {
        "node",
        cmd_path .. "html/vscode-html/html-language-features/server/dist/node/htmlServerMain.js",
        "--stdio"
    },
    json = {
        "node",
        cmd_path .. "json/vscode-json/json-language-features/server/dist/node/jsonServerMain.js",
        "--stdio"
    },
    python = {cmd_path .. "python/node_modules/.bin/pyright-langserver", "--stdio"},
    texlab = {cmd_path .. "latex/texlab"},
    tsserver = {cmd_path .. "typescript/node_modules/.bin/typescript-language-server", "--stdio"}
}

vim.g.diagnostics_active = true
function _G.toggle_diagnostics()
    if vim.g.diagnostics_active then
        vim.g.diagnostics_active = false
        vim.lsp.diagnostic.clear(0)
        vim.lsp.handlers["textDocument/publishDiagnostics"] = function()
        end
    else
        vim.g.diagnostics_active = true
        vim.lsp.handlers["textDocument/publishDiagnostics"] =
            vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics,
            {
                virtual_text = false,
                signs = true,
                underline = true,
                update_in_insert = false
            }
        )
    end
end

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

function M.hl(name)
    return vim.api.nvim_get_hl_by_name(name, true)
end

function M.exists(name)
    if vim.fn.hlexists(name) == 1 then
        local hl = M.hl(name)
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

function M.link(group, fallbacks, default)
    if not M.exists(group) then
        for _, fallback in pairs(fallbacks) do
            if M.exists(fallback) then
                vim.cmd("hi link " .. group .. " " .. fallback)
                return
            end
        end
        if default then
            vim.cmd("hi " .. group .. " " .. default)
        end
    end
end

function M.fix()
    -- dump({ fix = event })
    -- Default Groups
    for _, lsp in pairs({"Error", "Warning", "Information", "Hint"}) do
        local coc = lsp
        if lsp == "Information" then
            coc = "Info"
        end
        M.link("LspDiagnosticsDefault" .. lsp, {"Coc" .. coc .. "Sign"}, "guifg=" .. config[lsp])
        M.link("LspDiagnosticsVirtualText" .. lsp, {"LspDiagnosticsDefault" .. lsp})

        local color = defaults[lsp]
        local hl = M.hl("LspDiagnosticsDefault" .. lsp)
        if hl and hl.foreground then
            color = string.format("#%06x", hl.foreground)
        end
        M.link("LspDiagnosticsUnderline" .. lsp, {}, "gui=undercurl guisp=" .. color)
    end

    M.link("LspReferenceText", {"CocHighlightText", "CursorLine"})
    M.link("LspReferenceRead", {"CocHighlightRead", "LspReferenceText"})
    M.link("LspReferenceWrite", {"CocHighlightWrite", "LspReferenceText"})
end

function M.setup(options)
    config = vim.tbl_deep_extend("force", {}, defaults, options or {})
end
M.setup()

return M
