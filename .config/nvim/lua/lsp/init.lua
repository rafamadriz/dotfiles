if as._default(LSP.enabled) == true then
    require("lsp/servers")
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
        virtual_text = as._default(LSP.virtual_text, false),
        underline = as._default(LSP.diagnostic_underline),
        signs = as._default(LSP.diagnostic_signs),
        update_in_insert = false
    }
)
-- toggle diagnostics, FIXME: very hacky, find a better way
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
                virtual_text = as._default(LSP.virtual_text, false),
                signs = as._default(LSP.signs),
                underline = as._default(LSP.diagnostic_underline),
                update_in_insert = false
            }
        )
    end
end
