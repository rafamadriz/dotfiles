require "compe".setup {
    enabled = as._default(Completion.enabled),
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
        path = as._compe(Completion.path, {menu = "[P]", kind = "  (Path)"}),
        buffer = as._compe(Completion.buffer, {menu = "[B]", kind = "   (Buffer)"}),
        calc = as._compe(Completion.calc, {menu = "[C]", kind = "  (Calc)"}),
        vsnip = as._compe(Completion.snippets, {menu = "[S]", priority = 1500, kind = " ﬌  (Snippet)"}),
        nvim_lsp = as._compe(Completion.lsp, {menu = "[L]"}),
        spell = as._compe(Completion.spell, {menu = "[E]", kind = "  (Spell)"}),
        emoji = as._compe(Completion.emoji, {menu = "[ ﲃ ]"}),
        nvim_lua = {menu = "[]"}
    }
}
