---@module "lazy"
---@type LazySpec
return {
    "stevearc/overseer.nvim",
    lazy = false,
    config = function()
        require("overseer").setup {
            component_aliases = {
                -- Most tasks are initialized with the default components
                default = {
                    { "display_duration", detail_level = 2 },
                    "on_output_summarize",
                    "on_exit_set_status",
                    "on_complete_notify",
                    "on_complete_dispose",
                    -- Not default
                    "on_output_quickfix",
                },
            },
        }

        -- Restart last task
        -- https://github.com/stevearc/overseer.nvim/blob/master/doc/recipes.md#restart-last-task
        vim.api.nvim_create_user_command("OverseerRestartLast", function()
            local overseer = require "overseer"
            local tasks = overseer.list_tasks { recent_first = true }
            if vim.tbl_isempty(tasks) then
                vim.notify("No tasks found", vim.log.levels.WARN)
            else
                overseer.run_action(tasks[1], "restart")
            end
        end, {})

        -- :Make similar to vim-dispatch
        -- Modified to only open quickfix with `!`
        -- source: https://github.com/stevearc/overseer.nvim/blob/master/doc/recipes.md#make-similar-to-vim-dispatch
        vim.api.nvim_create_user_command("Make", function(params)
            -- Insert args at the '$*' in the makeprg
            local cmd, num_subs = vim.o.makeprg:gsub("%$%*", params.args)
            if num_subs == 0 then
                cmd = cmd .. " " .. params.args
            end
            local task = require("overseer").new_task {
                cmd = vim.fn.expandcmd(cmd),
                components = {
                    {
                        "on_output_quickfix",
                        open = params.bang,
                        open_height = 8,
                    },
                    "default",
                },
            }
            task:start()
        end, {
            desc = "Run your makeprg as an Overseer task",
            nargs = "*",
            bang = true,
        })
    end,
    keys = {
        { "<leader>tr", "<cmd>OverseerRun<CR>", desc = "Run task" },
        { "<leader>tt", "<cmd>OverseerToggle<CR>", desc = "Tasks toggle" },
        { "<leader>tl", "<cmd>OverseerRestartLast<CR>", desc = "Last task restart" },
        { "<leader>ti", "<cmd>OverseerInfo<CR>", desc = "Info tasks" },
    },
}
