local tex_utils = require("etiennecollin.config.luasnip")

return {
    s({ trig = "example"},
        fmta(
            [[
            \begin{example}{<>}
                <>
            \end{example}
            ]],
            {
                i(1),
                i(0),
            }
        )
    ),
    s({ trig = "subexample"},
        fmta(
            [[
            \begin{subexample}{<>}
                <>
            \end{subexample}
            ]],
            {
                i(1),
                i(0),
            }
        ),
        { condition = tex_utils.in_env("example") }
    ),
    s({ trig = "es"},
        fmta(
            [[
            \[
                \begin{split}
                    <>
                \end{split}
            \]
            ]],
            {
                i(0),
            }
        )
    ),
}
