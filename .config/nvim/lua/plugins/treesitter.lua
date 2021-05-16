if Treesitter.enabled == nil or Treesitter.enabled == true then
    require "nvim-treesitter.configs".setup {
        ensure_installed = Treesitter.parsers,
        highlight = {
            enable = true, -- false will disable the whole extension
            use_languagetree = true
        },
        indent = {enable = true}
    }
end
