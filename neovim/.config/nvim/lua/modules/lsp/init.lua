local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }

for type, icon in pairs(signs) do
    local hl = "LspDiagnosticsSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
        virtual_text = as._default(vim.g.code_lsp_virtual_text, false),
        underline = as._default(vim.g.code_lsp_diagnostic_underline),
        signs = as._default(vim.g.code_lsp_diagnostic_signs_enabled),
        update_in_insert = false,
    }
)

local borders = as._lsp_borders(vim.g.code_lsp_window_borders)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = borders })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = borders }
)

-- symbols for autocomplete
local lsp_symbols = {
    Class = "",
    Color = "",
    Constant = "",
    Constructor = "",
    Enum = "❐",
    EnumMember = "",
    Event = "",
    Field = "ﴲ",
    File = "",
    Folder = "",
    Function = "",
    Interface = "ﰮ",
    Keyword = "",
    Method = "",
    Module = "",
    Operator = "",
    Property = "",
    Reference = "",
    Snippet = "﬌",
    Struct = "ﳤ",
    Text = "",
    TypeParameter = "",
    Unit = "",
    Value = "",
    Variable = "[]",
}

local description = {
    "Class",
    "Color",
    "Constant",
    "Constructor",
    "Enum",
    "EnumMember",
    "Event",
    "Field",
    "File",
    "Folder",
    "Function",
    "Interface",
    "Keyword",
    "Method",
    "Module",
    "Operator",
    "Property",
    "Reference",
    "Snippet",
    "Struct",
    "Text",
    "TypeParameter",
    "Unit",
    "Value",
    "Variable",
}

local fix_offset = function(icon, desc)
    local fmt = string.format
    local item
    if as._default(vim.g.code_compe_item_with_text) then
        item = fmt(" %s  %s", icon, desc)
        if desc == "Variable" then
            item = fmt("%s %s", icon, desc)
        end
    else
        item = fmt(" %s", icon)
        if desc == "Variable" then
            item = fmt("%s", icon)
        end
    end
    return item
end

for _, v in pairs(description) do
    local kinds = vim.lsp.protocol.CompletionItemKind
    local index = kinds[v]
    if index ~= nil then
        kinds[index] = fix_offset(lsp_symbols[v], v)
    end
end

local M = {}
local fn = vim.fn

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
    },
}

function M.documentHighlight(client, bufnr)
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

-- Taken from https://www.reddit.com/r/neovim/comments/gyb077/nvimlsp_peek_defination_javascript_ttserver/
function M.preview_location(location, context, before_context)
    -- location may be LocationLink or Location (more useful for the former)
    context = context or 15
    before_context = before_context or 0
    local uri = location.targetUri or location.uri
    if uri == nil then
        return
    end
    local bufnr = vim.uri_to_bufnr(uri)
    if not vim.api.nvim_buf_is_loaded(bufnr) then
        fn.bufload(bufnr)
    end
    local borders = as._lsp_borders(vim.g.code_lsp_window_borders)
    local range = location.targetRange or location.range
    local contents = vim.api.nvim_buf_get_lines(
        bufnr,
        range.start.line - before_context,
        range["end"].line + 1 + context,
        false
    )
    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
    return vim.lsp.util.open_floating_preview(contents, filetype, { border = borders })
end

function M.preview_location_callback(_, method, result)
    local context = 15
    if result == nil or vim.tbl_isempty(result) then
        print("No location found: " .. method)
        return nil
    end
    if vim.tbl_islist(result) then
        M.floating_buf, M.floating_win = M.preview_location(result[1], context)
    else
        M.floating_buf, M.floating_win = M.preview_location(result, context)
    end
end

function M.PeekDefinition()
    if vim.tbl_contains(vim.api.nvim_list_wins(), M.floating_win) then
        vim.api.nvim_set_current_win(M.floating_win)
    else
        local params = vim.lsp.util.make_position_params()
        return vim.lsp.buf_request(
            0,
            "textDocument/definition",
            params,
            M.preview_location_callback
        )
    end
end

return M
