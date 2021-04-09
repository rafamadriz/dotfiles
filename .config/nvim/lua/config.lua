Theming = {
    -- Press <space>fc to see all available themes
    colorscheme = "edge",
    --[[ Some colorscheme have multiple styles to choose from.
      Available options:
      @gruvbox = medium, soft, hard
      @edge = default, aura, neon
      @sonokai = default, atlantis, andromeda, shusia, maia ]]
    colorscheme_style = "aura",
    -- Choose a stulusline:
    -- Options: galaxy, airline, eviline, gruvbox, minimal, rounded
    statusline = "eviline"
}

LSP = {
    -- values: true, false
    -- Enable or disable LSP globally
    enabled = true,
    -- Choose which servers to start automatically
    bash = true,
    clangd = true,
    css = true,
    emmet = true,
    json = true,
    lua = false,
    python = true,
    tsserver = true
}

Completion = {
    -- values: true, false
    -- Enable or disable completion globally
    enabled = true,
    autopairs = true,
    autotag = true,
    items = 10,
    -- Choose sources of completion
    snippets = true,
    lsp = true,
    buffer = true,
    path = true,
    calc = true,
    spell = true
}

Formatting = {
    -- if format_on_save is enable it will always trim trailing white spaces
    format_on_save = true,
    trim_trailing_space = true,
    indent_size = 2
}

Treesitter = {
    -- Treesitter can have performance issues, choose to enable or not
    enabled = true,
    rainbow = true,
    -- Set the parsers for Treesitter
    parsers = {
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
    }
}
