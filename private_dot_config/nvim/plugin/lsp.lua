local lsp, diagnostic = vim.lsp, vim.diagnostic
local aucmd, augroup = vim.api.nvim_create_autocmd, vim.api.nvim_create_augroup

local lsp_configs = {
    "lua_ls",
    "taplo",
    "rust_analyzer",
    "bashls",
    "ccls",
    "html",
    "cssls",
}
lsp.enable(lsp_configs)

diagnostic.config {
    severity_sort = true,
    underline = {
        severity = { diagnostic.severity.ERROR, diagnostic.severity.WARN },
    },
    float = {
        source = "if_many",
    },
}

local initial_virtext_cfg = vim.diagnostic.config().virtual_text
-- source: https://www.reddit.com/r/neovim/comments/1jm5atz/replacing_vimdiagnosticopen_float_with_virtual/
---@param jumpCount number
local function jump_with_virtline_diagnostics(jumpCount)
    pcall(vim.api.nvim_del_augroup_by_name, "jumpWithVirtLineDiags") -- prevent autocmd for repeated jumps

    diagnostic.jump { count = jumpCount, wrap = false }

    diagnostic.config {
        virtual_text = false,
        virtual_lines = { current_line = true },
    }

    vim.defer_fn(function() -- deferred to not trigger by jump itself
        aucmd("CursorMoved", {
            desc = "User(once): Reset diagnostics virtual lines",
            once = true,
            group = augroup("jumpWithVirtLineDiags", {}),
            callback = function() diagnostic.config { virtual_lines = false, virtual_text = initial_virtext_cfg } end,
        })
    end, 1)
end

local setup_mappings = function(bufnr)
    local map = vim.keymap.set
    -- map("n", "gd", lsp.buf.definition, { desc = "Go to definition", buffer = bufnr })
    map("n", "]d", function() jump_with_virtline_diagnostics(1) end, { desc = "Next diagnostic" })
    map("n", "[d", function() jump_with_virtline_diagnostics(-1) end, { desc = "Prev diagnostic" })
    map("n", "]D", function() jump_with_virtline_diagnostics(math.huge) end, { desc = "Last diagnostic" })
    map("n", "[D", function() jump_with_virtline_diagnostics(-math.huge) end, { desc = "First diagnostic" })
    map("n", "<C-k>", lsp.buf.signature_help, { desc = "Signature help", buffer = bufnr })
    map("n", "gry", lsp.buf.type_definition, { desc = "Go to type definition", buffer = bufnr })
    map("n", "grc", lsp.codelens.run, { desc = "Run code lens", buffer = bufnr })
    map("n", "<leader>lf", function() lsp.buf.format { async = true } end, { desc = "Format", buffer = bufnr })
    map("n", "<leader>lo", diagnostic.open_float, { desc = "Open float diagnostics", buffer = bufnr })
    map(
        "n",
        "<leader>lh",
        function() lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
        { desc = "Toggle inlay hints", buffer = bufnr }
    )
    map("n", "<leader>ll", function()
        diagnostic.config {
            virtual_lines = { current_line = true },
            virtual_text = false,
        }

        aucmd("CursorMoved", {
            group = augroup("line-diagnostics", { clear = true }),
            callback = function()
                diagnostic.config { virtual_lines = false, virtual_text = initial_virtext_cfg }
                return true
            end,
        })
    end, { desc = "Line diagnostics", buffer = bufnr })
    map("n", "<leader>lp", function()
        ---@diagnostic disable-next-line: missing-parameter
        local params = lsp.util.make_position_params()
        return lsp.buf_request(0, "textDocument/definition", params, function(_, result)
            if result == nil or vim.tbl_isempty(result) then
                return
            end
            lsp.util.preview_location(result[1])
        end)
    end, { desc = "Peek definition", buffer = bufnr })
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
        aucmd({ "CursorHold", "CursorHoldI", "InsertLeave", "BufEnter" }, {
            group = under_cursor_highlights,
            desc = "Highlight references under the cursor",
            buffer = bufnr,
            callback = lsp.buf.document_highlight,
        })
        aucmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
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
        setup_mappings(args.buf)
        setup_aucmds(client, args.buf)

        -- Automatically show completion
        -- if client:supports_method(lsp.protocol.Methods.textDocument_completion) then
        --     -- Optional: trigger autocompletion on EVERY keypress. May be slow!
        --     local chars = {}
        --     for i = 32, 126 do
        --         table.insert(chars, string.char(i))
        --     end
        --     client.server_capabilities.completionProvider.triggerCharacters = chars
        --
        --     lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        -- end
    end,
})
