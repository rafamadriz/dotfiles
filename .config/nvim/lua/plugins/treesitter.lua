if as._default(vim.g.neon_treesitter_enabled) == true then
    vim.cmd [[packadd nvim-treesitter]]
    require "nvim-treesitter.configs".setup {
        ensure_installed = vim.g.neon_treesitter_parsers or "all",
        highlight = {
            enable = true, -- false will disable the whole extension
            use_languagetree = true
        },
        indent = {enable = true}
    }
end
