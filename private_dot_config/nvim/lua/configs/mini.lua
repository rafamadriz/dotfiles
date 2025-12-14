require "configs.statusline"
require("mini.align").setup()
require("mini.icons").setup()
require("mini.bracketed").setup()
require("mini.completion").setup({
    mappings = {
        scroll_down = "<C-d>",
        scroll_up = "<C-b>",
    }
})
require("mini.cmdline").setup({
    autocorrect = {
        enable = false,
    }
})

-- Enhance text objects
local ai = require "mini.ai"
ai.setup {
    n_lines = 10,
    mappings = { around_last = "", inside_last = "" },
    custom_textobjects = {
        i = ai.gen_spec.treesitter({ a = "@conditional.outer", i = "@conditional.inner" }, {}),
        f = ai.gen_spec.treesitter({ a = "@function.outer",    i = "@function.inner" }, {}),
        c = ai.gen_spec.treesitter({ a = "@class.outer",       i = "@class.inner" }, {}),
    },
}

local hipatterns = require('mini.hipatterns')
hipatterns.setup {
    highlighters = {
        fixme = { pattern = "FIXME", group = "MiniHipatternsFixme" },
        hack  = { pattern = "HACK",  group = "MiniHipatternsHack"  },
        todo  = { pattern = "TODO",  group = "MiniHipatternsTodo"  },
        note  = { pattern = "NOTE",  group = "MiniHipatternsNote"  },

        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = hipatterns.gen_highlighter.hex_color(),
    },
}

require("mini.surround").setup {
    mappings = {
        add       = "ys", -- Add surrounding in Normal and Visual modes
        delete    = "ds", -- Delete surrounding
        replace   = "cs", -- Replace surrounding
        find      = "",   -- Find surrounding (to the right)
        find_left = "",   -- Find surrounding (to the left)
        highlight = "",   -- Highlight surrounding
    },
}

-- Git
local git = require "mini.git"
git.setup {}
vim.cmd.cnoreabbrev "G Git"

require("mini.diff").setup {
    view = {
        style = "sign",
        signs = { add = "+", change = "~", delete = "-" }
    },
}

vim.api.nvim_create_autocmd({ "FileType" }, {
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
vim.keymap.set("n", "<leader>gt", require("mini.diff").toggle_overlay, { desc = "toggle diff overlay" })
vim.keymap.set("n", "<leader>gs", ":Git add -- %<CR>",                 { desc = "stage buffer" })
vim.keymap.set("n", "<leader>gu", ":Git restore --staged -- %<CR>",    { desc = "unstage buffer" })
vim.keymap.set("n", "<leader>gl", ":Git lg<CR>",                       { desc = "log oneline" })
vim.keymap.set("n", "<leader>gf", ":Git log --patch -- %<CR>",         { desc = "full log patch (buffer)" })
vim.keymap.set("n", "<leader>gF", ":Git log --patch<CR>",              { desc = "full log patch" })
vim.keymap.set("n", "<leader>gd", ":Git diff -- %<CR>",                { desc = "diff (buffer)" })
vim.keymap.set("n", "<leader>gD", ":Git diff<CR>",                     { desc = "diff" })

-- Snippets
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
    local can_expand = #snippets.expand { insert = false } > 0
    if can_expand then
        vim.schedule(snippets.expand)
        return ""
    end
    local is_active = snippets.session.get() ~= nil
    if is_active then
        snippets.session.jump "next"
        return ""
    end
    return "\t"
end

local jump_prev = function() snippets.session.jump "prev" end

vim.keymap.set("i", "<Tab>", expand_or_jump, { expr = true })
vim.keymap.set("i", "<S-Tab>", jump_prev)

-- Clues
local miniclue = require "mini.clue"
miniclue.setup {
    window = {
        delay = 200,
    },
    triggers = {
        -- Leader triggers
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },

        -- `[` and `]` keys
        { mode = "n", keys = "[" },
        { mode = "n", keys = "]" },

        -- Built-in completion
        { mode = "i", keys = "<C-x>" },

        -- `g` key
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },

        -- Marks
        { mode = "n", keys = "'" },
        { mode = "n", keys = "`" },
        { mode = "x", keys = "'" },
        { mode = "x", keys = "`" },

        -- Registers
        { mode = "n", keys = '"' },
        { mode = "x", keys = '"' },
        { mode = "i", keys = "<C-r>" },
        { mode = "c", keys = "<C-r>" },

        -- Window commands
        { mode = "n", keys = "<C-w>" },

        -- `z` key
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },

        -- coerce plugin ./plugin/coerce.lua
        { mode = "v", keys = "cr" },
        { mode = "n", keys = "cr" },
    },
    clues = {
        miniclue.gen_clues.square_brackets(),
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
    },
}
