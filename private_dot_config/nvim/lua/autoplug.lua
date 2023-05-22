local aucmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

aucmd({ "BufWritePost" }, {
    pattern = "*",
    desc = "Format on save",
    group = augroup("FormatOnSave", { clear = true }),
    command = "FormatWrite",
})
