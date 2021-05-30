local g = vim.g

-- =====================
--- General Settings ---
-- =====================
g.neon_timeoutlen = 400
g.neon_cmdheight = 1
g.neon_updatetime = 300
g.neon_scrolloff = 10
g.neon_relativenumber = true
g.neon_cursorline = true
g.neon_word_wrap = false
g.neon_preserve_cursor = true
g.neon_highlight_yank = true
g.neon_listchars = false
g.neon_indent_guides = true
g.neon_explorer_side = "right"
g.neon_format_on_save = true
g.neon_trim_trailing_space = true
g.neon_indent_size = 4

-- =================
--- Colors/Style ---
-- =================
-- Press <space>ft to see all available themes
g.neon_colorscheme = "neon"
g.neon_colorscheme_style = "doom"
g.neon_statusline = "classic"
g.neon_statusline_color = "neon"
g.neon_rainbow_parentheses = true

-- ================
---     LSP     ---
-- ================
g.neon_lsp_enabled = true
g.neon_lsp_virtual_text = false
g.neon_lsp_win_borders = "double"
g.neon_lsp_diagnostic_signs = true
g.neon_lsp_document_highlight = false
g.neon_lsp_diagnostic_underline = true
g.neon_lsp_autostart_blacklist = {"lua", "bash", "json"}

-- ===============
--- Completion ---
-- ===============
g.neon_compe_enabled = true
g.neon_compe_autopairs = true
g.neon_compe_items = 10
g.neon_compe_sources_blacklist = {}

-- ===============
--- Treesitter ---
-- ===============
g.neon_treesitter_enabled = true
g.neon_treesitter_parsers = {
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
