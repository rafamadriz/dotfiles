local M = {}

M.ai = function()
    local ai = require "mini.ai"
    ai.setup {
        n_lines = 500,
        mappings = { around_last = "", inside_last = "" },
        custom_textobjects = {
            i = ai.gen_spec.treesitter({ a = "@conditional.outer", i = "@conditional.inner" }, {}),
            f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
            c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
    }
end

M.operators = function()
    require("mini.operators").setup {
        exchange = { prefix = "gx" },
        replace = { prefix = "gX" },
        multiply = { prefix = "" },
        sort = { prefix = "" },
        evaluate = { prefix = "" },
    }
end

M.notify = function()
    local notify = require "mini.notify"
    notify.setup {}
    vim.api.nvim_create_user_command("Mes", function() notify.show_history() end, {})
    vim.notify = notify.make_notify()
end

M.git = function()
    local git = require "mini.git"
    git.setup {}
    vim.cmd.cnoreabbrev "G Git"

    vim.api.nvim_create_autocmd("Filetype", {
        pattern = { "git", "diff" },
        callback = function(args)
            if not vim.api.nvim_buf_is_valid(args.buf) then
                return
            end
            local buf_name = vim.api.nvim_buf_get_name(args.buf)
            if not vim.startswith(buf_name, "minigit://") then
                return
            end

            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.MiniGit.diff_foldexpr()"

            vim.keymap.set({ "n", "x" }, "K", git.show_at_cursor, { buffer = args.buf, desc = "Show git data" })
            vim.keymap.set({ "n", "x" }, "gd", git.show_diff_source, { buffer = args.buf, desc = "Go to git source" })
        end,
    })
end

M.snippets = function()
    local snippets = require "mini.snippets"
    local gen_loader = snippets.gen_loader

    local match_strict = function(snips)
        -- Do not match with whitespace to cursor's left
        return snippets.default_match(snips, { pattern_fuzzy = "%S+" })
    end

    snippets.setup {
        snippets = {
            gen_loader.from_file(vim.fn.stdpath "config" .. "/snippets/global.json"),
            gen_loader.from_lang(),
        },
        mappings = { expand = "", jump_next = "", jump_prev = "" },
        expand = { match = match_strict },
    }

    local expand_or_jump = function()
        local can_expand = #MiniSnippets.expand { insert = false } > 0
        if can_expand then
            vim.schedule(MiniSnippets.expand)
            return ""
        end
        local is_active = MiniSnippets.session.get() ~= nil
        if is_active then
            MiniSnippets.session.jump "next"
            return ""
        end
        return "\t"
    end

    local jump_prev = function() MiniSnippets.session.jump "prev" end

    vim.keymap.set("i", "<Tab>", expand_or_jump, { expr = true })
    vim.keymap.set("i", "<S-Tab>", jump_prev)
end

---@module "lazy"
---@type LazySpec
return {
    {
        "echasnovski/mini.nvim",
        lazy = false,
        version = false,
        dependencies = { { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" } },
        config = function()
            M.ai()
            M.operators()
            M.notify()
            M.git()
            M.snippets()
            require("plugins.mini.statusline").setup()
            require("mini.align").setup {}
            require("mini.icons").setup {}
        end,
    },
}
