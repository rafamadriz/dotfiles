if as._default(vim.g.neon_lsp_enabled) == true then
    require("lsp.servers")
end
-- LSP Diagnostics
-- ================================================
vim.fn.sign_define(
    "LspDiagnosticsSignError",
    {texthl = "LspDiagnosticsSignError", text = " ", numhl = "LspDiagnosticsSignError"}
)
vim.fn.sign_define(
    "LspDiagnosticsSignWarning",
    {texthl = "LspDiagnosticsSignWarning", text = " ", numhl = "LspDiagnosticsSignWarning"}
)
vim.fn.sign_define(
    "LspDiagnosticsSignInformation",
    {texthl = "LspDiagnosticsSignInformation", text = "", numhl = "LspDiagnosticsSignInformation"}
)
vim.fn.sign_define(
    "LspDiagnosticsSignHint",
    {texthl = "LspDiagnosticsSignHint", text = "", numhl = "LspDiagnosticsSignHint"}
)

vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
        virtual_text = as._default(vim.g.neon_lsp_virtual_text, false),
        underline = as._default(vim.g.neon_lsp_diagnostic_underline),
        signs = as._default(vim.g.neon_lsp_diagnostic_signs),
        update_in_insert = false
    }
)

local borders = as._lsp_borders(vim.g.neon_lsp_win_borders)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = borders})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = borders})

-- symbols for autocomplete
local lsp_symbols = {
    Class = "   (Class)",
    Color = "   (Color)",
    Constant = "   (Constant)",
    Constructor = "   (Constructor)",
    Enum = " 練 (Enum)",
    EnumMember = "   (EnumMember)",
    Field = " ﴲ  (Field)",
    File = "   (File)",
    Folder = "   (Folder)",
    Function = "   (Function)",
    Interface = " ﰮ  (Interface)",
    Keyword = "   (Keyword)",
    Method = "   (Method)",
    Module = "   (Module)",
    Property = " 襁 (Property)",
    Snippet = " ﬌  (Snippet)",
    Struct = " ﳤ  (Struct)",
    Text = "   (Text) ",
    Unit = "   (Unit)",
    Value = "   (Value)",
    Variable = "[] (Variable)",
    Reference = "   (Reference)",
    Event = " ﲀ  (Event)",
    Operator = "   (Operator)",
    TypeParameter = "   (TypeParameter)"
}

for kind, symbol in pairs(lsp_symbols) do
    local kinds = vim.lsp.protocol.CompletionItemKind
    local index = kinds[kind]

    if index ~= nil then
        kinds[index] = symbol
    end
end
