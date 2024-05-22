-- TODO: make a function that checks if cwd is a git repo and returns true/false
-- use that as a `cond` option (:help lazy.nvim-lazy.nvim-plugin-spec) for git plugins.
return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "-" },
                topdelete = { text = "-" },
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]g", function()
                    if vim.wo.diff then return "]c" end
                    vim.schedule(function() gs.next_hunk() end)
                    return "<Ignore>"
                end, { expr = true, desc = "Next git hunk" })

                map("n", "[g", function()
                    if vim.wo.diff then return "[c" end
                    vim.schedule(function() gs.prev_hunk() end)
                    return "<Ignore>"
                end, { expr = true, desc = "Previous git hunk" })

                -- Actions
                map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
                map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
                map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
                map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
                map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
                map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
                map("n", "<leader>gP", ":Gitsigns preview_hunk_inline<CR>", { desc = "Preview hunk" })
                map("n", "<leader>gB", ":Gitsigns blame_line<CR>", { desc = "Blame line" })
                map("n", "<leader>gl", gs.toggle_current_line_blame, { desc = "Blame current line" })
                map("n", "<leader>gt", gs.toggle_deleted, { desc = "Toggle old versions of hunks" })

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "inner git hunk" })
            end,
        },
    },
    {
        "sindrets/diffview.nvim",
        keys = {
            { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diff" },
            { "<leader>gD", "<cmd>DiffviewOpen HEAD -- %<CR>", desc = "Diff buffer" },
            { "<leader>gh", "<cmd>DiffviewFileHistory<CR>", desc = "File history" },
            { "<leader>gH", "<cmd>DiffviewFileHistory %<CR>", desc = "History buffer" },
        },
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
        config = function()
            local cb = require("diffview.config").diffview_callback
            require("diffview").setup {
                view = {
                    default = {
                        winbar_info = true,
                    },
                    file_history = {
                        winbar_info = true,
                    },
                },
                key_bindings = {
                    view = { { "n", "q", "<Cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
                    file_panel = {
                        { "n", "q", "<Cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
                    },
                    file_history_panel = {
                        { "n", "q", "<Cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
                    },
                    option_panel = { { "n", "q", cb "close", { desc = "Close Diffview" } } },
                },
            }
        end,
    },
    {
        "linrongbin16/gitlinker.nvim",
        cmd = "GitLink",
        config = function()
            require("gitlinker").setup {
                router = {
                    file_only = {
                        ["^github%.com"] = "https://github.com/"
                            .. "{_A.ORG}/"
                            .. "{_A.REPO}/blob/"
                            .. "{_A.REV}/"
                            .. "{_A.FILE}",
                        ["^gitlab%.com"] = "https://gitlab.com/"
                            .. "{_A.ORG}/"
                            .. "{_A.REPO}/blob/"
                            .. "{_A.REV}/"
                            .. "{_A.FILE}",
                        ["^bitbucket%.org"] = "https://bitbucket.org/"
                            .. "{_A.ORG}/"
                            .. "{_A.REPO}/src/"
                            .. "{_A.REV}/"
                            .. "{_A.FILE}",
                        ["^codeberg%.org"] = "https://codeberg.org/"
                            .. "{_A.ORG}/"
                            .. "{_A.REPO}/src/commit/"
                            .. "{_A.REV}/"
                            .. "{_A.FILE}",
                        ["^git%.samba%.org"] = "https://git.samba.org/?p="
                            .. "{string.len(_A.ORG) > 0 and (_A.ORG .. '/') or ''}" -- 'p=samba.git;' or 'p=bbaumbach/samba.git;'
                            .. "{_A.REPO .. '.git'};a=blob;"
                            .. "f={_A.FILE};",
                    },
                    homepage = {
                        ["^github%.com"] = "https://github.com/" .. "{_A.ORG}/" .. "{_A.REPO}/",
                        ["^gitlab%.com"] = "https://gitlab.com/" .. "{_A.ORG}/" .. "{_A.REPO}/blob/",
                        ["^bitbucket%.org"] = "https://bitbucket.org/" .. "{_A.ORG}/" .. "{_A.REPO}/src/",
                        ["^codeberg%.org"] = "https://codeberg.org/" .. "{_A.ORG}/" .. "{_A.REPO}/",
                        ["^git%.samba%.org"] = "https://git.samba.org/?p="
                            .. "{string.len(_A.ORG) > 0 and (_A.ORG .. '/') or ''}" -- 'p=samba.git;' or 'p=bbaumbach/samba.git;'
                            .. "{_A.REPO .. '.git'};a=blob;",
                    },
                },
            }
        end,
        keys = {
            { "<leader>gyl", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank git permlink" },
            { "<leader>gyL", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git permlink" },
            -- blame
            { "<leader>gyb", "<cmd>GitLink blame<cr>", mode = { "n", "v" }, desc = "Yank git blame link" },
            { "<leader>gyB", "<cmd>GitLink! blame<cr>", mode = { "n", "v" }, desc = "Open git blame link" },
            -- default branch
            {
                "<leader>gyd",
                "<cmd>GitLink default_branch<cr>",
                mode = { "n", "v" },
                desc = "Copy default branch link",
            },
            {
                "<leader>gyD",
                "<cmd>GitLink! default_branch<cr>",
                mode = { "n", "v" },
                desc = "Open default branch link",
            },
            -- default branch
            {
                "<leader>gyc",
                "<cmd>GitLink current_branch<cr>",
                mode = { "n", "v" },
                desc = "Copy current branch link",
            },
            {
                "<leader>gyC",
                "<cmd>GitLink! current_branch<cr>",
                mode = { "n", "v" },
                desc = "Open current branch link",
            },
            -- File only
            {
                "<leader>gyf",
                "<cmd>GitLink file_only<cr>",
                mode = { "n", "v" },
                desc = "Copy file link",
            },
            {
                "<leader>gyF",
                "<cmd>GitLink! file_only<cr>",
                mode = { "n", "v" },
                desc = "Open file link",
            },
            -- Homepage
            {
                "<leader>gyh",
                "<cmd>GitLink homepage<cr>",
                mode = { "n", "v" },
                desc = "Copy homepage link",
            },
            {
                "<leader>gyH",
                "<cmd>GitLink! homepage<cr>",
                mode = { "n", "v" },
                desc = "Open homepage link",
            },
        },
    },
    {
        "akinsho/git-conflict.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = { disable_diagnostics = true },
    },
}
