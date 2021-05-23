Opts = {
    timeoutlen = 400,
    cmdheight = 1,
    updatetime = 300,
    scrolloff = 10,
    relativenumber = true,
    cursorline = true,
    word_wrap = false,
    preserve_cursor = true,
    highlight_yank = true,
    listchars = false,
    indent_guides = true,
    explorer_side = "right"
}

Theming = {
    -- Press <space>ft to see all available themes
    colorscheme = "neon",
    --[[ Some colorscheme have multiple styles to choose from:
      @gruvbox = medium, soft, hard.
      @neon = default, dark, light.]]
    colorscheme_style = "doom",
    -- Options: classic, arrow, slant
    statusline = "slant",
    -- Options: nord, neon, gruvbox, wombat
    statusline_color = "neon"
}

LSP = {
    -- @values: true, false
    enabled = true,
    virtual_text = false,
    document_highlight = false,
    diagnostic_signs = true,
    diagnostic_underline = true,
    autostart = {
        bash = false,
        clangd = true,
        json = false,
        latex = true,
        lua = false,
        python = true,
        -- WebDev
        html = true,
        css = true,
        tsserver = true,
        emmet = true
    }
}

Completion = {
    -- @values: true, false
    enabled = true,
    autopairs = true,
    items = 8,
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
