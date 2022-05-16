local telescope = require "telescope"
local actions = require "telescope.actions"
telescope.setup {
    defaults = {
        prompt_prefix = "  ",
        selection_caret = "❯ ",
        sorting_strategy = "ascending",
        mappings = {
            i = {
                -- actions.which_key shows the mappings for your picker,
                -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                ["<C-h>"] = "which_key",
                ["<C-j>"] = actions.cycle_history_next,
                ["<C-k>"] = actions.cycle_history_prev,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                ["<M-q>"] = actions.send_to_qflist + actions.open_qflist,
            },
            n = {
                ["<C-c>"] = actions.close,
                ["q"] = actions.close,
            }
        },
        layout_config = {
            horizontal = {
                height = 0.75,
                width = 0.8,
                prompt_position = "top",
            }
        },
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
        find_files = {
            hidden = true,
            no_ignore = true,
        },
        buffers = {
            layout_config = { preview_width = 0.6 },
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
    },
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        }
    }
}

-- telescope extensions
-- FZF syntax:
--    Token   | Match type                  | Description
-----------------------------------------------------------------------------
--    sbtrkt  | fuzzy-match                 | Items that match sbtrkt
--    'wild   | exact-match (quoted)        | Items that include wild
--    ^music  | prefix-exact-match          | Items that start with music
--    .mp2$   | suffix-exact-match          | Items that end with .mp3
--    !fire   | inverse-exact-match         | Items that do not include fire
--    !^music | inverse-prefix-exact-match  | Items that do not start with music
--    !.mp2$  | inverse-suffix-exact-match  | Items that do not end with .mp3
telescope.load_extension('fzf')
telescope.load_extension('projects')
--------------------------------------------------------------------------------
-- Mappings & Which-key
--------------------------------------------------------------------------------

local builtins = require('telescope.builtin')
local mappings = {
    ["<leader>"] = {
        ["<space>"] = { builtins.find_files, "Find files" },
        ["f"] = {
            name = "Find",
            ["a"] = { builtins.builtin, "All builtins" },
            ["f"] = { builtins.find_files, "Find files" },
            ["g"] = { builtins.grep_string, "Grep string under cursor" },
            ["s"] = { builtins.live_grep, "Search string" },
            ["h"] = { builtins.help_tags, "Help tags" },
            ["c"] = { builtins.commands, "Commands" },
            ["r"] = { builtins.oldfiles, "Recent files" },
            ["m"] = { builtins.man_pages, "Man pages" },
            ["q"] = { builtins.quickfixhistory, "Quickfix history" },
            ["p"] = { "<cmd>Telescope projects<CR>", "Projects" },
        },
        ["g"] = {
            name = "Git",
            ["f"] = { builtins.git_files, "Files" },
            ["b"] = { builtins.git_branches, "Branches" },
            ["c"] = { builtins.git_commits, "Commits" },
            ["C"] = { builtins.git_bcommits, "Buffer commits" },
            ["z"] = { builtins.git_stash, "Stash" },
        },
        ["b"] = {
            name = "Buffer",
            ["b"] = { builtins.buffers, "Buffers" },
            ["g"] = { builtins.current_buffer_fuzzy_find, "Grep string" },
        },
        ["l"] = {
            ["d"] = { function() builtins.diagnostics { bufnr = 0 } end, "Document diagnostics" },
            ["s"] = { builtins.lsp_document_symbols, "Document symbols" },
            ["wd"] = { builtins.diagnostics, "Workspace diagnostics" },
            ["ws"] = { builtins.lsp_workspace_symbols, "Workspace symbols" },
        },
    }
}

require("which-key").register(mappings, { mode = 'n' })
