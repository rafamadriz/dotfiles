local aucmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local map = vim.keymap.set

aucmd({ "BufWritePost" }, {
    pattern = "*",
    desc = "Format on save",
    group = augroup("FormatOnSave", { clear = true }),
    command = "FormatWrite",
})

aucmd({ "LspAttach" }, {
    pattern = "*",
    desc = "LSP plugins",
    group = augroup("LspPlugins", { clear = true }),
    callback = function()
        map("n", "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Document diagnostics" })
        map("n", "<leader>lD", "<cmd>Telescope diagnostics<CR>", { desc = "Workspace diagnostics" })
        map("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Document symbols" })
        map("n", "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<CR>", { desc = "Workspace symbols" })
        map("n", "<leader>lo", "<cmd>Neotree toggle right document_symbols<CR>", { desc = "Toggle symbols outline" })
    end,
})
