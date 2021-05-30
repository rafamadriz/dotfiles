vim.g.indent_blankline_enabled = as._default(vim.g.neon_indent_guides)
vim.g.indent_blankline_char = "│"
vim.g.indent_blankline_show_first_indent_level = false
vim.g.indent_blankline_buftype_exclude = {"terminal", "nofile"}
vim.g.indent_blankline_space_char_blankline = " "
vim.g.indent_blankline_strict_tabs = true
vim.g.indent_blankline_filetype_exclude = {
    "help",
    "vimwiki",
    "startify",
    "man",
    "git",
    "packer",
    "gitmessengerpopup",
    "diagnosticpopup",
    "markdown",
    "lspinfo"
}
vim.g.indent_blankline_show_current_context = true
vim.g.indent_blankline_context_patterns = {
    "class",
    "function",
    "method",
    "^if",
    "while",
    "for",
    "with",
    "func_literal",
    "block",
    "try",
    "except",
    "argument_list",
    "object",
    "dictionary"
}
