Theming = {
    -- Press <space>fc to see all available themes
    colorscheme = "onebuddy",
    --[[ Some colorscheme have multiple styles to choose from.
      here are the available options:
      For @gruvbox = medium, soft, hard
      For @edge = default, aura, neon
      For @sonokai = default, atlantis, andromeda, shusia, maia ]]
    colorscheme_style = "",
    -- Choose a stulusline:
    -- Options: galaxy, airline, eviline, gruvbox, minimal
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
    lua = true,
    python = true,
    tsserver = true
}

Completion = {
    -- values: true, false
    -- Enable or disable completion globally
    enabled = true,
    -- Choose sources of completion
    snippets = true,
    lsp = true,
    buffer = true,
    path = true,
    calc = true,
    spell = true
}
