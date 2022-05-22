---@diagnostic disable: undefined-global

return {
    s({
        trig = "rt",
        name = "return keyword",
        dscr = "return keyword shortcut",
    }, {
        t "return ",
        i(0),
    }),

    s({
        trig = "l",
        name = "local variable",
        dscr = "create a local variable",
    }, {
        t "local ",
        i(1, "name"),
        t " = ",
        i(0),
    }),
    s(
        {
            trig = "fn",
            name = "function",
            dscr = "create a function",
        },
        fmt(
            [[
            {}function{}({})
                {}
            end
            {}
	]],
            {
                i(1),
                i(2),
                i(3),
                i(4, "-- code"),
                i(0),
            }
        )
    ),
}
