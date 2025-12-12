local lsp, diagnostic = vim.lsp, vim.diagnostic
local aucmd, augroup = vim.api.nvim_create_autocmd, vim.api.nvim_create_augroup

lsp.enable {
    "lua_ls",
    "taplo",
    "rust_analyzer",
    "bashls",
    "ccls",
    "html",
    "cssls",
    "pyright",
    -- "ts_ls",
    "css_variables",
    "gopls",
    "jsonls",
    "vtsls",
}

diagnostic.config {
    severity_sort = true,
    underline = {
        severity = { diagnostic.severity.ERROR, diagnostic.severity.WARN },
    },
    float = {
        source = "if_many",
    },
    jump = {
        float = true,
    },
}

local setup_keymaps = function(bufnr)
    local map = vim.keymap.set
    -- map("n", "gd", lsp.buf.definition, { desc = "Go to definition", buffer = bufnr })
    map("n", "<C-k>", lsp.buf.signature_help, { desc = "Signature help", buffer = bufnr })
    map("n", "grc", lsp.codelens.run, { desc = "Run code lens", buffer = bufnr })
    map({ "v", "n" }, "<leader>lf", function() lsp.buf.format { async = true } end, { desc = "Format", buffer = bufnr })
    map("n", "<leader>ll", diagnostic.open_float, { desc = "Line diagnostics", buffer = bufnr })
    map(
        "n",
        "<leader>lh",
        function() lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
        { desc = "Toggle inlay hints", buffer = bufnr }
    )
end

---@param client vim.lsp.Client
---@param bufnr number
local setup_aucmds = function(client, bufnr)
    if client:supports_method(lsp.protocol.Methods.textDocument_codeLens) then
        aucmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
            desc = "Refresh code lens",
            group = augroup("LspCodeLens", { clear = true }),
            buffer = bufnr,
            callback = lsp.codelens.refresh,
        })
    end

    if client:supports_method(lsp.protocol.Methods.textDocument_documentHighlight) then
        local under_cursor_highlights = augroup("LspDocHighlight", { clear = false })
        aucmd({ "CursorHold", "CursorHoldI" }, {
            group = under_cursor_highlights,
            desc = "Highlight references under the cursor",
            buffer = bufnr,
            callback = lsp.buf.document_highlight,
        })
        aucmd({ "CursorMoved" }, {
            group = under_cursor_highlights,
            desc = "Clear highlight references",
            buffer = bufnr,
            callback = lsp.buf.clear_references,
        })
    end

    aucmd("DiagnosticChanged", {
        desc = "Update diagnostics loclist",
        group = augroup("UpdateDiagnosticLoc", { clear = true }),
        callback = function(args)
            diagnostic.setloclist { open = false }
            if #diagnostic.get(args.buf) == 0 then
                vim.cmd "silent! lclose"
            end
        end,
    })
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
