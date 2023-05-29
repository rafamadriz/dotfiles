return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = { "Telescope" },
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
            {
                "rafamadriz/telescope-live-grep-args.nvim",
                -- Use this brachn until <https://github.com/nvim-telescope/telescope-live-grep-args.nvim/pull/59> is merged
                branch = "fix-quote-prompt",
            },
        },
        config = function()
            local actions = require "telescope.actions"
            local layout = require "telescope.actions.layout"
            local action_state = require "telescope.actions.state"
            require("telescope").setup {
                defaults = {
                    mappings = {
                        i = {
                            ["<C-h>"] = "which_key",
                            ["<C-j>"] = actions.cycle_history_next,
                            ["<C-k>"] = actions.cycle_history_prev,
                            ["<C-o>"] = layout.cycle_layout_next,
                            ["<C-i>"] = layout.cycle_layout_prev,
                            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                            ["<M-q>"] = actions.send_to_qflist + actions.open_qflist,
                            ["<C-y>"] = function()
                                -- yank current selection value to system clipboard
                                -- useful to copy file path or commit hash in their respective pickers,
                                -- tough not all pickers have a selection value.
                                local selected_entry = action_state.get_selected_entry()
                                vim.fn.setreg("+", selected_entry.value)
                                vim.api.nvim_win_close(0, true)
                            end,
                        },
                        n = {
                            ["<C-c>"] = actions.close,
                            ["q"] = actions.close,
                        },
                    },
                    layout_strategy = "bottom_pane",
                    path_display = { truncate = 3 },
                    sorting_strategy = "ascending",
                    layout_config = {
                        horizontal = {
                            prompt_position = "top",
                        },
                        bottom_pane = {
                            height = 15,
                        },
                    },
                    cycle_layout_list = { "horizontal", "vertical", "bottom_pane", "center" },
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--hidden",
                        "--glob=!.git/",
                        "--trim",
                    },
                    file_ignore_patterns = {
                        "^node_modules/",
                        "nvim/undo/",
                        "%.git/",
                        "%.mkv",
                        "%.png",
                        "%.jpg",
                        "%.jpeg",
                        "%.webp",
                        "%.pdf",
                        "%.mp3",
                        "%.mp4",
                        "%.m4a",
                        "%.opus",
                        "%.flac",
                        "%.doc",
                        "%.zip",
                        "%.odt",
                        "%.ots",
                        "%.docx",
                        "%.xlsx",
                        "%.xls",
                        "%.pptx",
                        "%.dxvk",
                        "%.rpf",
                        "%.dll",
                        "%.kdbx",
                        "%.exe",
                        "%.iso",
                        "%.gif",
                        "%.epub",
                        "%.AppImage",
                        "%.apk",
                        "%.gz",
                    },
                },
                pickers = {
                    current_buffer_fuzzy_find = {
                        -- theme = "ivy",
                    },
                    find_files = {
                        hidden = true,
                        -- no_ignore = true,
                    },
                    buffers = {
                        path_display = { "smart" },
                        -- theme = "dropdown",
                        previewer = true,
                        ignore_current_buffer = true,
                        sort_mru = true,
                        mappings = {
                            i = {
                                ["<c-d>"] = actions.delete_buffer,
                            },
                            n = {
                                ["<c-d>"] = actions.delete_buffer,
                            },
                        },
                    },
                    git_commits = {
                        mappings = {
                            i = {
                                ["<C-f>"] = function()
                                    -- Open in diffview
                                    local selected_entry = action_state.get_selected_entry()
                                    local value = selected_entry.value
                                    -- close Telescope window properly prior to switching windows
                                    vim.api.nvim_win_close(0, true)
                                    vim.cmd "stopinsert"
                                    vim.schedule(function() vim.cmd(("DiffviewOpen %s^!"):format(value)) end)
                                end,
                            },
                        },
                    },
                },
                extensions = {
                    live_grep_args = {
                        mappings = {
                            i = {
                                ["<C-'>"] = require("telescope-live-grep-args.actions").quote_prompt(),
                                ["<C-i>"] = require("telescope-live-grep-args.actions").quote_prompt {
                                    postfix = " --iglob ",
                                    quote_char = "",
                                },
                                ["<C-;>"] = require("telescope-live-grep-args.actions").quote_prompt {
                                    postfix = " --word-regexp ",
                                    quote_char = "",
                                },
                            },
                        },
                    },
                },
            }
            require("telescope").load_extension "fzf"
            require("telescope").load_extension "live_grep_args"
            require("telescope").load_extension "projects"
        end,
        keys = {
            -- find
            { "<leader><Space>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
            { "<leader>fa", "<cmd>Telescope builtin<CR>", desc = "All pickers" },
            { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
            { "<leader>fg", "<cmd>Telescope live_grep_args<CR>", desc = "Grep project" },
            {
                "<leader>fG",
                "<cmd>Telescope live_grep grep_open_files=true<CR>",
                desc = "Grep open files",
            },
            {
                "<leader>fw",
                "<cmd>Telescope grep_string<CR>",
                desc = "Grep word under cursor",
                mode = { "n", "v" },
            },
            { "<leader>?", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
            { "<leader>fc", "<cmd>Telescope commands<CR>", desc = "Commands" },
            { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
            { "<leader>fq", "<cmd>Telescope quickfix<CR>", desc = "Quickfix" },
            { "<leader>fQ", "<cmd>Telescope quickfixhistory<CR>", desc = "Quickfix history" },
            { "<leader>fp", "<cmd>Telescope projects<CR>", desc = "Projects" },
            { "<leader>`", "<cmd>Telescope resume<CR>", desc = "Resume last picker" },
            -- buffers
            { "<leader>bb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
            {
                "<leader>bg",
                "<cmd>Telescope current_buffer_fuzzy_find<CR>",
                desc = "Grep on current buffer",
            },
            -- git
            { "<leader>gf", "<cmd>Telescope git_files<CR>", desc = "Git files" },
            { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Branches" },
            { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
            { "<leader>gC", "<cmd>Telescope git_bcommits<CR>", desc = "Buffer commits" },
            { "<leader>gm", "<cmd>Telescope git_status<CR>", desc = "Modified files" },
        },
    },
}
