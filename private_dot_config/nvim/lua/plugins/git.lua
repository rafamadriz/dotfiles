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
            map(
                "n",
                "<leader>gB",
                function() gs.blame_line { full = true } end,
                { desc = "Blame line" }
            )
            map("n", "<leader>gl", gs.toggle_current_line_blame, { desc = "Blame current line" })
            map("n", "<leader>gt", gs.toggle_deleted, { desc = "Toggle old versions of hunks" })

            -- Text object
            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "inner git hunk" })
        end,
    }
end

M.neogit = function()
    local neogit = require "neogit"
    neogit.setup {
        disable_commit_confirmation = true,
        integrations = { diffview = true },
        signs = {
            section = { "", "" },
            item = { "", "" },
            hunk = { "", "" },
        },
    }
end

M.diffview = function()
    local cb = require("diffview.config").diffview_callback
    require("diffview").setup {
        key_bindings = {
            disable_defaults = false, -- Disable the default key bindings
            view = { ["q"] = ":DiffviewClose<cr>" },
            file_panel = { ["q"] = ":DiffviewClose<cr>" },
            file_history_panel = {
                ["q"] = ":DiffviewClose<cr>",
                ["?"] = cb "options",
            },
            option_panel = { ["q"] = cb "close" },
        },
    }
end

return M
