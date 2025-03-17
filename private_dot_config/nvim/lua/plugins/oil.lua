return {
    "stevearc/oil.nvim",
    lazy = false,
    keys = { { "<leader>e", "<cmd>Oil<cr>", desc = "File explorer" } },
    config = function()
        local oil = require "oil"
        oil.setup {
            default_file_explorer = true,
            delete_to_trash = true,
            columns = {
                "icon",
                -- "permissions",
                "size",
                "mtime",
            },
            view_options = {
                show_hidden = true,
            },
            keymaps = {
                ["Q"] = "actions.close",
                ["<C-c>"] = false,
                ["yp"] = {
                    -- source: https://www.reddit.com/r/neovim/comments/1czp9zr/comment/l5hv900/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
                    desc = "Copy filepath to system clipboard",
                    callback = function()
                        require("oil.actions").copy_entry_path.callback()
                        local copied = vim.fn.getreg(vim.v.register)
                        vim.fn.setreg("+", copied)
                        vim.notify("Copied to system clipboard:\n" .. copied, vim.log.levels.INFO, {})
                    end,
                },
                ["g:"] = {
                    -- source: https://github.com/stevearc/oil.nvim/pull/318
                    desc = "Run shell command on file under cursor",
                    callback = function()
                        vim.ui.input({ prompt = "command: ", completion = "shellcmd" }, function(input)
                            if input == "" or input == nil then return end
                            local file_path = oil.get_current_dir() .. oil.get_cursor_entry().name
                            if file_path == "" or file_path == nil then return end
                            vim.api.nvim_command(":! " .. input .. ' "' .. file_path .. '"')
                        end)
                    end,
                },
            },
        }
    end,
}
