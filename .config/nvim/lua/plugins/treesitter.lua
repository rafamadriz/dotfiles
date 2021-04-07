if Treesitter.enabled == nil or Treesitter.enabled == true then
    require "nvim-treesitter.configs".setup {
        ensure_installed = {
            "javascript",
            "typescript",
            "tsx",
            "html",
            "css",
            "c",
            "lua",
            "bash",
            "python",
            "json",
            "yaml"
        }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        highlight = {
            enable = true, -- false will disable the whole extension
            use_languagetree = true
        },
        indent = {enable = true},
        rainbow = {enable = Treesitter.rainbow},
        autotag = {enable = Treesitter.autotag}
    }
end
