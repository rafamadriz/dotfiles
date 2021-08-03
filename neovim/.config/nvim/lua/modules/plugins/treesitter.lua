local M = {}

M.config = function()
    if as._default(vim.g.code_treesitter_enabled) then
        require("nvim-treesitter.configs").setup {
            ensure_installed = vim.g.code_treesitter_parsers_install or "maintained",
            ignore_install = vim.g.code_treesitter_parsers_ignore or {},
            highlight = {
                enable = as._default(vim.g.code_treesitter_highlight), -- false will disable the whole extension
                use_languagetree = true,
            },
            indent = { enable = false },
        }
    end
end

return M
