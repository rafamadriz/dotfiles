return {
    -- Required by others
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons" },

    -- Package manager
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        config = true,
    },

    -- Improve editing experience and motions
    {
        "numToStr/Comment.nvim",
        keys = {
            "gcc",
            "gbc",
            "gcA",
            "gco",
            "gcO",
            { "gc", mode = { "n", "v" } },
            { "gb", mode = { "n", "v" } },
        },
        config = function()
            require("Comment").setup {
                ignore = "^$",
            }
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup {
                disable_filetype = { "TelescopePrompt", "vim" },
                ignored_next_char = "[%w%.]",
            }
        end,
    },
    {
        "kylechui/nvim-surround",
        keys = {
            "ys",
            "yss",
            "ds",
            "cs",
            { "ys", mode = { "v" } },
        },
        config = function()
            require("nvim-surround").setup {
                keymaps = {
                    visual = "ys",
                    visual_line = false,
                },
            }
        end,
    },
    {
        "ggandor/leap.nvim",
        lazy = false,
        init = function()
            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = function() vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" }) end,
            })
        end,
        config = function()
            local leap = require "leap"
            leap.opts.safe_labels = {}
            leap.add_default_mappings()
            leap.init_highlight(true)
            leap.opts.special_keys.prev_target = "<backspace>"
        end,
    },
    {
        "ggandor/flit.nvim",
        keys = { "f", "F", "t", "T" },
        opts = {
            keys = { f = "f", F = "F", t = "t", T = "T" },
            -- A string like "nv", "nvo", "o", etc.
            labeled_modes = "v",
            multiline = false,
            -- Like `leap`s similar argument (call-specific overrides).
            -- E.g.: opts = { equivalence_classes = {} }
            opts = {},
        },
    },

    -- Other useful tools
    {
        "rafamadriz/bigfile.nvim",
        lazy = false,
        opts = {
            filesize = 2, -- size of the file in MiB, the plugin round file sizes to the closest MiB
            pattern = { "*" }, -- autocmd pattern or function see <### Overriding the detection of big files>
            features = { -- features to disable
                "indent_blankline",
                "illuminate",
                "lsp",
                "treesitter",
                "treesitter_context",
                -- "syntax",
                "matchparen",
                "vimopts",
                -- "filetype",
            },
        },
    },
    { "kevinhwang91/nvim-bqf", ft = "qf" },
    {
        "stevearc/oil.nvim",
        lazy = false,
        keys = { { "<leader>e", "<cmd>Oil<cr>", desc = "File explorer" } },
        config = function()
            local oil = require "oil"
            oil.setup {
                default_file_explorer = true,
                delete_to_trash = true,
                view_options = {
                    show_hidden = true,
                },
                keymaps = {
                    ["<C-d>"] = "actions.close",
                    ["<C-c>"] = false,
                },
            }
            -- source: https://github.com/stevearc/oil.nvim/pull/318
            vim.api.nvim_create_autocmd({ "FileType" }, {
                pattern = { "oil" },
                callback = function()
                    vim.keymap.set("n", "g:", function()
                        vim.ui.input({ prompt = "command: ", completion = "shellcmd" }, function(input)
                            if input == "" or input == nil then return end
                            local file_path = oil.get_current_dir() .. oil.get_cursor_entry().name
                            if file_path == "" or file_path == nil then return end
                            vim.api.nvim_command(":! " .. input .. ' "' .. file_path .. '"')
                        end)
                    end, { buffer = 0, desc = "Run shell command on file under cursor" })
                end,
            })
        end,
    },
    {
        "ahmedkhalf/project.nvim",
        lazy = false,
        config = function()
            require("project_nvim").setup {
                detection_methods = { "pattern", "lsp" },
                show_hidden = true, -- show hidden files in telescope
            }
            local ok, fzf = pcall(require, "fzf-lua")
            if ok then
                vim.keymap.set("n", "<leader>fp", function()
                    fzf.fzf_exec(function(add_to_results)
                        local contents = require("project_nvim").get_recent_projects()
                        for _, project in pairs(contents) do
                            add_to_results(project)
                        end
                        -- close the fzf named pipe, this signals EOF and terminates the fzf "loading" indicator.
                        add_to_results()
                    end, {
                        prompt = "Projects> ",
                        actions = {
                            ["default"] = function(choice)
                                vim.cmd.edit(choice[1])
                                vim.cmd.cd(choice[1])
                            end,
                            ["ctrl-x"] = {
                                function(choice)
                                    local history = require "project_nvim.utils.history"
                                    local delete =
                                        vim.fn.confirm("Delete '" .. choice[1] .. "' projects? ", "&Yes\n&No", 2)
                                    if delete == 1 then history.delete_project { value = choice[1] } end
                                end,
                                fzf.actions.resume,
                            },
                        },
                    })
                end, { silent = true, desc = "Projects" })
            end
        end,
    },
    {
        "NMAC427/guess-indent.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = true,
    },
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        keys = { { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Undotree" } },
        config = function()
            vim.g.undotree_WindowLayout = 4
            vim.g.undotree_SplitWidth = 45
            vim.g.undotree_SetFocusWhenToggle = 1
        end,
    },
    {
        "ThePrimeagen/harpoon",
        keys = {
            { "<C-\\>", function() require("harpoon.ui").toggle_quick_menu() end },
            { "<leader>a", function() require("harpoon.mark").add_file() end },
            { "<leader>1", function() require("harpoon.ui").nav_file(1) end },
            { "<leader>2", function() require("harpoon.ui").nav_file(2) end },
            { "<leader>3", function() require("harpoon.ui").nav_file(3) end },
            { "<leader>4", function() require("harpoon.ui").nav_file(4) end },
        },
    },
}
