local lsp_config = {}
DATA_PATH = vim.fn.stdpath("data")

lsp_config.capabilities = vim.lsp.protocol.make_client_capabilities()
lsp_config.capabilities.textDocument.completion.completionItem.snippetSupport = true

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
    elseif LSP.highlight_word == false then
        return nil
    end
end

-- LSP commands
-- ==================================================
lsp_config.cmds = {
    bash = {DATA_PATH .. "/lspinstall/bash/node_modules/.bin/bash-language-server", "start"},
    css = {
        "node",
        DATA_PATH .. "/lspinstall/css/vscode-css/css-language-features/server/dist/node/cssServerMain.js",
        "--stdio"
    },
    clangd = {DATA_PATH .. "/lspinstall/cpp/clangd/bin/clangd"},
    html = {
        "node",
        DATA_PATH .. "/lspinstall/html/vscode-html/html-language-features/server/dist/node/htmlServerMain.js",
        "--stdio"
    },
    json = {
        "node",
        DATA_PATH .. "/lspinstall/json/vscode-json/json-language-features/server/dist/node/jsonServerMain.js",
        "--stdio"
    },
    python = {DATA_PATH .. "/lspinstall/python/node_modules/.bin/pyright-langserver", "--stdio"},
    texlab = {DATA_PATH .. "/lspinstall/latex/texlab"},
    tsserver = {DATA_PATH .. "/lspinstall/typescript/node_modules/.bin/typescript-language-server", "--stdio"}
}

-- Add LSP colors to colorschemes that don't support it yet
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
