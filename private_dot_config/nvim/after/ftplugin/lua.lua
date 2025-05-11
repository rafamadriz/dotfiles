-- Related to:
-- https://github.com/neovim/neovim/issues/33577
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            hint = {
                enable = true,
            },
        },
    },
})
