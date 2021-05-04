Opts = {
    jump_last_pos = true,
    highlight_yank = true,
    relativenumber = true,
    scrolloff = 10,
    wrap = false,
    cursorline = true,
    listchars = true
}

Theming = {
    -- Press <space>fc to see all available themes
    colorscheme = "one",
    --[[ Some colorscheme have multiple styles to choose from.
      Available options:
      @gruvbox = medium, soft, hard ]]
    colorscheme_style = "",
    -- Choose a stulusline:
    -- Options: classic, slant, minimal, default
    statusline = "classic",
    -- Options: gruvbox, nord, dark
    statusline_color = "nord"
}

LSP = {
    -- @values: true, false
    enabled = true,
    ---------------
    -- Autostart --
    ---------------
    bash = true,
    clangd = true,
    json = true,
    latex = true,
    lua = false,
    python = true,
    -- WebDev
    html = true,
    css = true,
    tsserver = true,
    emmet = true
}

Completion = {
    -- @values: true, false
    enabled = true,
    autopairs = true,
    items = 10,
    -------------
    -- Sources --
    -------------
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
    enabled = true,
    rainbow = true,
    -------------
    -- Parsers --
    -------------
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
