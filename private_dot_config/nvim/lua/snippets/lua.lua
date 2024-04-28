local luasnip = require "luasnip"
local snippet = luasnip.snippet
local i = luasnip.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    snippet(
        { trig = "l", name = "local variable", desc = "create a local variable" },
        fmt(
            [[
            local {} = {}
        ]],
            { i(1, "name"), i(2, "") }
        )
    ),
    snippet(
        { trig = "fn", name = "function", desc = "create function" },
        fmt(
            [[
            function {}({})
                {}
            end
        ]],
            { i(1, ""), i(2, ""), i(3, "") }
        )
    ),
    snippet(
        { trig = "rt", name = "return", desc = "return a value" },
        fmt(
            [[
            return {}
        ]],
            { i(1, "") }
        )
    ),
    snippet(
        { trig = "pr", name = "print", desc = "print a value" },
        fmt(
            [[
            print({})
        ]],
            { i(1, "") }
        )
    ),
}
