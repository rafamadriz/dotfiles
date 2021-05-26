require "compe".setup {
    enabled = as._default(vim.g.neon_compe_enabled),
    autocomplete = true,
    debug = false,
    min_length = 2,
    preselect = "always",
    throttle_time = 80,
    source_timeout = 200,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    documentation = true,
    source = {
        path = as._compe(
            "path",
            {
                menu = "[P]",
                kind = "  (Path)"
            }
        ),
        buffer = as._compe(
            "buffer",
            {
                menu = "[B]",
                kind = "   (Buffer)"
            }
        ),
        calc = as._compe(
            "calc",
            {
                menu = "[C]",
                kind = "  (Calc)"
            }
        ),
        vsnip = as._compe(
            "snippets",
            {
                menu = "[S]",
                priority = 1500,
                kind = " ﬌  (Snippet)"
            }
        ),
        spell = as._compe(
            "spell",
            {
                menu = "[E]",
                kind = "  (Spell)"
            }
        ),
        nvim_lsp = as._compe("lsp", {menu = "[L]"}),
        emoji = as._compe("emoji", {menu = "[ ﲃ ]"}),
        nvim_lua = {menu = "[]"}
    }
}
