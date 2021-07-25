local M = {}

M.gitsigns = function()
    require("gitsigns").setup {
        signs = {
            add = { hl = "GitSignsAdd", text = "┃" },
            change = { hl = "GitSignsChange", text = "┃" },
            delete = { hl = "GitSignsDelete", text = "契" },
            topdelete = { hl = "GitSignsDelete", text = "契" },
            changedelete = { hl = "GitSignsChange", text = "~" },
        },
        keymaps = { noremap = true, buffer = true },
    }
end

M.neogit = function()
    require("neogit").setup {
        disable_context_highlighting = false,
        disable_commit_confirmation = true,
        integrations = { diffview = true },
        signs = {
            -- { CLOSED, OPENED }
            section = { "", "" },
            item = { "", "" },
            hunk = { "", "" },
        },
    }
end

M.diffview = function()
    require("diffview").setup {
        key_bindings = {
            disable_defaults = false, -- Disable the default key bindings
            view = { ["q"] = ":DiffviewClose<cr>" },
            file_panel = { ["q"] = ":DiffviewClose<cr>" },
        },
    }
end

M.gitlinker = function()
    require("gitlinker").setup()
end

return M
