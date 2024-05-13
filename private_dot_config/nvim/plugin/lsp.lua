local aucmd, augroup = vim.api.nvim_create_autocmd, vim.api.nvim_create_augroup
local lsp, diagnostic, map = vim.lsp, vim.diagnostic, vim.keymap.set

diagnostic.config {
    virtual_text = {
        source = "if_many",
        spacing = 4,
    },
    severity_sort = true,
    underline = {
        severity = diagnostic.severity.ERROR,
    },
    float = {
        source = "if_many",
        border = "rounded",
    },
}

lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, { border = "rounded" })
lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, { border = "rounded" })

local setup_mappings = function(_, bufnr)
    map("n", "]d", diagnostic.goto_next, { desc = "Next diagnostics ", buffer = bufnr })
    map("n", "[d", diagnostic.goto_prev, { desc = "Previous diagnostics", buffer = bufnr })
    map("n", "gd", lsp.buf.definition, { desc = "Go to definition", buffer = bufnr })
    map("n", "gr", lsp.buf.references, { desc = "Go to references", buffer = bufnr })
    map("n", "gm", lsp.buf.implementation, { desc = "Go to implementation", buffer = bufnr })
    map("n", "gy", lsp.buf.type_definition, { desc = "Go to type definition", buffer = bufnr })
    map("n", "K", lsp.buf.hover, { desc = "Document hover", buffer = bufnr })
    map("n", "<C-k>", lsp.buf.signature_help, { desc = "Signature help", buffer = bufnr })

    map({ "n", "v" }, "<leader>la", lsp.buf.code_action, { desc = "Code action", buffer = bufnr })
    map("n", "<leader>lc", lsp.codelens.run, { desc = "Run code lens", buffer = bufnr })
    map("n", "<leader>lr", lsp.buf.rename, { desc = "Rename symbol", buffer = bufnr })
    map("n", "<leader>lf", function() lsp.buf.format { async = true } end, { desc = "LSP Format", buffer = bufnr })
    map("n", "<leader>ll", diagnostic.open_float, { desc = "Line diagnostics", buffer = bufnr })
    map("n", "<leader>lp", function()
        local params = lsp.util.make_position_params()
        return lsp.buf_request(0, "textDocument/definition", params, function(_, result)
            if result == nil or vim.tbl_isempty(result) then return end
            lsp.util.preview_location(result[1], { border = "rounded" })
        end)
    end, { desc = "Peek definition", buffer = bufnr })
end

local setup_aucmds = function(client, bufnr)
    if client.server_capabilities["codeLensProvider"] then
        aucmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
            desc = "Refresh code lens",
            group = augroup("LspCodeLens", { clear = true }),
            buffer = bufnr,
            callback = function() lsp.codelens.refresh() end,
        })
    end

    if client.server_capabilities["documentHighlightProvider"] then
        local under_cursor_highlights = augroup("LspDocHighlight", { clear = false })
        aucmd({ "CursorHold", "CursorHoldI", "InsertLeave", "BufEnter" }, {
            group = under_cursor_highlights,
            desc = "Highlight references under the cursor",
            buffer = bufnr,
            callback = function() lsp.buf.document_highlight() end,
        })
        aucmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
            group = under_cursor_highlights,
            desc = "Clear highlight references",
            buffer = bufnr,
            callback = function() lsp.buf.clear_references() end,
        })
    end

    aucmd("DiagnosticChanged", {
        desc = "Update diagnostics loclist",
        group = augroup("UpdateDiagnosticLoc", { clear = true }),
        callback = function(args)
            diagnostic.setloclist { open = false }
            if #vim.diagnostic.get(args.buf) == 0 then vim.cmd "silent! lclose" end
        end,
    })
end

aucmd("LspAttach", {
    desc = "My LSP settings",
    group = augroup("UserLspConfig", {}),
    callback = function(args)
        local client = lsp.get_client_by_id(args.data.client_id)
        setup_mappings(client, args.buf)
        setup_aucmds(client, args.buf)
    end,
})
