local alpha = require "alpha"
local startify = require "alpha.themes.startify"
alpha.setup(startify.config)

--------------------------------------------------------------------------------
-- Startify
--------------------------------------------------------------------------------
startify.section.top_buttons.val = {
    startify.button("e", "New file", ":enew<CR>"),
    { type = "padding", val = 1 },
    startify.button("f", "Find Files", "<cmd>Telescope find_files<CR>"),
    startify.button("r", "Recent Files", "<cmd>Telescope oldfiles<CR>"),
    startify.button("w", "Grep Word", "<cmd>Telescope live_grep<CR>"),
    startify.button("h", "Help Tags", "<cmd>Telescope help_tags<CR>"),
    startify.button("p", "Projects", "<cmd>Telescope projects<CR>"),
    startify.button("s", "Load Session", "<cmd>SessionLoad<CR>"),
    startify.button(
        "d",
        "Dotfiles",
        "<cmd>chdir ~/.local/share/chezmoi/ | e ~/.local/share/chezmoi/<CR>"
    ),
}
startify.section.mru_cwd.val = { { type = "padding", val = 0 } }
