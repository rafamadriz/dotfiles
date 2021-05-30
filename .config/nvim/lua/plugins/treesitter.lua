if as._default(vim.g.neon_treesitter_enabled) == true then
    require "nvim-treesitter.configs".setup {
        ensure_installed = vim.g.neon_treesitter_parsers or "all",
        highlight = {
            enable = true, -- false will disable the whole extension
            use_languagetree = true
        },
        indent = {enable = true},
        rainbow = {
            enable = as._default(vim.g.neon_rainbow_parentheses),
            extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
            max_file_lines = 1000 -- Do not enable for files with more than 1000 lines, int
        }
    }
end
