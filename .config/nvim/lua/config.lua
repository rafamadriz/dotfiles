local g = vim.g
-----------------------------------------------------------------------------//
--- General Settings
-----------------------------------------------------------------------------//
g.neon_timeoutlen = 300
g.neon_colorcolumn = 0
g.neon_cmdheight = 1
g.neon_updatetime = 300
g.neon_scrolloff = 10
g.neon_relativenumber = true
g.neon_cursorline = true
g.neon_word_wrap = false
g.neon_preserve_cursor = true
g.neon_highlight_yank = true
g.neon_listchars = false
g.neon_indent_guides = false
g.neon_explorer_side = "right"
g.neon_format_on_save = true
g.neon_trim_trailing_space = true
g.neon_indent_size = 4

-----------------------------------------------------------------------------//
--- Colors/Style
-----------------------------------------------------------------------------//
-- Press <space>ht to see all available themes
g.neon_colorscheme = "onepro"
-- See :h themes-nvim for help
g.themes_italic_comment = true
g.themes_italic_keyword = true
g.themes_italic_boolean = true
g.themes_italic_function = true
g.themes_italic_variable = false
-- @options: classic, arrow, slant
g.neon_statusline = "classic"
-- @options: gruvbox, neon, nord, wombat
g.neon_statusline_color = "neon"

-----------------------------------------------------------------------------//
--- LSP
-----------------------------------------------------------------------------//
g.neon_lsp_enabled = true
g.neon_lsp_virtual_text = false
g.neon_lsp_window_borders = "single"
g.neon_lsp_signature_help = true
g.neon_lsp_diagnostic_signs = true
g.neon_lsp_document_highlight = false
g.neon_lsp_diagnostic_underline = true
g.neon_lsp_autostart_blacklist = { "lua" }

-----------------------------------------------------------------------------//
--- Completion
-----------------------------------------------------------------------------//
g.neon_compe_enabled = true
g.neon_compe_autocomplete = false
g.neon_compe_doc_window_border = "single"
g.neon_compe_autopairs = true
g.neon_compe_items = 10
g.neon_compe_sources_blacklist = {}

-----------------------------------------------------------------------------//
--- Treesitter
-----------------------------------------------------------------------------//
g.neon_treesitter_enabled = true
g.neon_treesitter_parsers_install = "maintained"
g.neon_treesitter_parsers_ignore = { "turtle", "verilog", "beancount" }

-----------------------------------------------------------------------------//
-- Startify
-----------------------------------------------------------------------------//
g.startify_footer = ""
-- @options: center, pad
g.startify_header_position = "center"
-- set g.startify_header_ascii = "cowsay" for random quote and cow.
g.startify_header_ascii = {
    "Y88b Y88                           Y8b Y88888P ,e,            ",
    " Y88b Y8  ,e e,   e88 88e  888 8e   Y8b Y888P   '  888 888 8e ",
    "b Y88b Y d88 88b d888 888b 888 88b   Y8b Y8P   888 888 888 88b",
    "8b Y88b  888   , Y888 888P 888 888    Y8b Y    888 888 888 888",
    "88b Y88b  'YeeP'  '88 88'  888 888     Y8P     888 888 888 888",
}
