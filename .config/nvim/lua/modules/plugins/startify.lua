local M = {}

M.config = function()
    vim.g.startify_lists = {
        { type = "sessions", header = { "   Sessions" } },
        { type = "commands", header = { "   Commands" } },
        { type = "files", header = { "   Recent Files" } },
        { type = "bookmarks", header = { "   Bookmarks" } },
    }
    vim.g.startify_bookmarks = {
        { i = "~/.config/nvim/init.lua" },
        { c = "~/.config/nvim/lua/config.lua" },
        { p = "~/.config/nvim/lua/modules/plugins/init.lua" },
    }
    vim.g.startify_commands = {
        { "Find files", ":Telescope fd" },
        { "Recent files", ":Telescope oldfiles" },
        { "Execute command", ":Telescope commands" },
        { "Help Tags", ":Telescope help_tags" },
        { "Sync Plugins", ":PackerSync" },
        { "Planets", ":Telescope planets" },
    }

    -- if start neovim in a directory that contains a Session.vim, that session will be loaded automatically
    vim.g.startify_session_autoload = 1
    -- Let Startify take care of buffers
    vim.g.startify_session_delete_buffers = 1
    -- Similar to Vim-rooter
    vim.g.startify_change_to_vcs_root = 1
    -- Unicode
    vim.g.startify_fortune_use_unicode = 1
    -- Automatically update sessions
    vim.g.startify_session_persistence = 1
    -- Get rid of empy buffer on quit
    vim.g.startify_enable_special = 0
    -- The number of files to list.
    vim.g.startify_files_number = 10
    -- The number of spaces used for left padding.
    vim.g.startify_padding_left = 3
    -- Sort sessions by modification time
    vim.g.startify_session_sort = 1
    -- Header and footer
    if vim.g.code_startify_footer ~= nil then
        vim.g.startify_custom_footer = "startify#center([g:code_startify_footer])"
    end
    local posi = vim.g.startify_header_position or "center"
    if vim.g.code_startify_header_ascii ~= nil then
        if vim.g.startify_header_ascii == "cowsay" then
            vim.g.startify_custom_header = "startify#" .. posi .. "(startify#fortune#cowsay())"
        else
            vim.g.startify_custom_header = "startify#" .. posi .. "(g:code_startify_header_ascii)"
        end
    end
end

return M
