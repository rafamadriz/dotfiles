local lsp, diagnostic = vim.lsp, vim.diagnostic
local aucmd, augroup = vim.api.nvim_create_autocmd, vim.api.nvim_create_augroup

lsp.enable {
    -- "lua_ls",
    "taplo",
    "rust_analyzer",
    "bashls",
    -- "ccls",
    "html",
    "cssls",
    "pyright",
    "ts_ls",
    "css_variables",
    "gopls",
    "jsonls",
    "clangd",
    -- "vtsls",
}

-- disable gitlab server that automatically runs on :lsp enable
-- because it uses npx so it run any remote package you don't have in
-- your PATH and it's enabled for a bunch for filetypes.
-- https://github.com/neovim/nvim-lspconfig/blob/a683e0ddf0cf64c6cd689e18ffb480ade3c162b7/lsp/gitlab_duo.lua#L316-L348
lsp.config("gitlab_duo", { cmd = "", filetypes = {} })


diagnostic.config {
    severity_sort = true,
    underline = {
        severity = { diagnostic.severity.ERROR, diagnostic.severity.WARN },
    },
    float = { source = "if_many", },
}

local setup_keymaps = function(bufnr)
    local map = vim.keymap.set
    map("n", "<C-k>", lsp.buf.signature_help,     { desc = "Signature help",                 buf = bufnr })
    map("n", "<leader>ll", diagnostic.open_float, { desc = "Line diagnostics",               buf = bufnr })
    map("n", "<leader>lq", diagnostic.setqflist,  { desc = "Quickfix list with diagnostics", buf = bufnr })
    map({ "v", "n" }, "<leader>lf", function()
        lsp.buf.format { async = true }
    end, { desc = "Format", buf = bufnr })
    map( "n", "<leader>lh", function()
        lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
        { desc = "Toggle inlay hints", buf = bufnr })
end

---@param client vim.lsp.Client
---@param bufnr number
local setup_aucmds = function(client, bufnr)
    if client:supports_method(lsp.protocol.Methods.textDocument_documentHighlight) then
        local under_cursor_highlights = augroup("LspDocHighlight", { clear = false })
        aucmd({ "CursorHold", "CursorHoldI" }, {
            group = under_cursor_highlights,
            desc = "Highlight references under the cursor",
            buf = bufnr,
            callback = lsp.buf.document_highlight,
        })
        aucmd({ "CursorMoved" }, {
            group = under_cursor_highlights,
            desc = "Clear highlight references",
            buf = bufnr,
            callback = lsp.buf.clear_references,
        })
    end
end

aucmd("LspAttach", {
    desc = "My LSP settings",
    group = augroup("UserLspConfig", {}),
    callback = function(args)
        ---@type vim.lsp.Client
        local client = assert(lsp.get_client_by_id(args.data.client_id))
        setup_keymaps(args.buf)
        setup_aucmds(client, args.buf)
    end,
})
