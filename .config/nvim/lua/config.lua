Opts = {
    preserve_cursor = true,
    highlight_yank = true,
    relativenumber = true,
    cursorline = true,
    listchars = true,
    wrap = false,
    timeoutlen = 500,
    updatetime = 300,
    scrolloff = 10,
    explorer_side = "right"
}

Theming = {
    -- Press <space>fc to see all available themes
    colorscheme = "neon",
    --[[ Some colorscheme have multiple styles to choose from:
      @gruvbox = medium, soft, hard.
      @neon = default, dark, light.]]
    colorscheme_style = "",
    -- Options: classic, slant, minimal, vscode, default
    statusline = "slant",
    -- Options: gruvbox, nord, dark
    statusline_color = "nord"
}

LSP = {
    -- @values: true, false
    enabled = true,
    virtual_text = false,
    highlight_word = true,
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
    ---------------------------
    -- Sources of Completion --
    ---------------------------
    snippets = true,
    lsp = true,
    buffer = true,
    path = true,
    calc = true,
    spell = true,
    emoji = true
}

Formatting = {
    -- if format_on_save is enable it will always trim trailing white spaces
    format_on_save = true,
    trim_trailing_space = true,
    indent_size = 2
}

Treesitter = {
    enabled = true,
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
