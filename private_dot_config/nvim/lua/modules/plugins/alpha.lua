local M = {}

M.config = function()
    local alpha = require "alpha"
    local startify = require "alpha.themes.startify"
    local chezmoi_home = "~/.local/share/chezmoi/private_dot_config/nvim/"
    startify.section.header.val = vim.g.code_startify_header_ascii
    startify.section.top_buttons.val = {
        startify.button("e", "New file", ":enew<CR>"),
        { type = "padding", val = 1 },
        startify.button("f", "Find Files", ":Telescope find_files<CR>"),
        startify.button("r", "Recent Files", ":Telescope oldfiles<CR>"),
        startify.button("w", "Grep Word", ":Telescope live_grep<CR>"),
        startify.button("h", "Help Tags", ":Telescope help_tags<CR>"),
        startify.button("p", "Projects", ":Telescope projects<CR>"),
        startify.button("s", "Last Session", ":lua require'persistence'.load({last = true})<CR>"),
    }
    startify.section.bottom_buttons.val = {
        startify.file_button(chezmoi_home .. "lua/config.lua", "c"),
        startify.file_button(chezmoi_home .. "init.lua", "i"),
        startify.file_button(chezmoi_home .. "lua/modules/plugins/init.lua", "l"),
        { type = "padding", val = 1 },
        startify.button("q", "Quit", ":quitall<CR>"),
    }
    startify.opts = {
        layout = {
            { type = "padding", val = 2 },
            startify.section.header,
            { type = "padding", val = 2 },
            startify.section.top_buttons,
            startify.section.mru,
            { type = "padding", val = 1 },
            startify.section.bottom_buttons,
        },
        opts = {
            margin = 3,
        },
    }
    alpha.setup(require("alpha.themes.startify").opts)
end

return M
