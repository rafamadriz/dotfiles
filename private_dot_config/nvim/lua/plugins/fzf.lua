return {
    {
        "ibhagwan/fzf-lua",
        cmd = { "FzfLua" },
        config = function()
            -- local actions = require "fzf-lua.actions"
            require("fzf-lua").setup {
                winopts = {
                    preview = {
                        layout = "vertical",
                    },
                },
                fzf_opts = {
                    ["--history"] = vim.fn.stdpath "data" .. "/fzf-lua-history",
                },
                files = {
                    fzf_opts = {
                        ["--history"] = vim.fn.stdpath "data" .. "/fzf-lua-files-history",
                    },
                    cwd_prompt = false,
                },
                grep = {
                    rg_glob = true,
                    rg_opts = [[--column --hidden --glob "!**/.git/**" --line-number --no-heading --color=always --smart-case --max-columns=4096 -e]],
                    fzf_opts = {
                        ["--history"] = vim.fn.stdpath "data" .. "/fzf-lua-grep-history",
                    },
                },
                keymap = {
                    fzf = {
                        ["ctrl-q"] = "select-all+accept",
                        ["ctrl-a"] = "select-all",
                        ["ctrl-d"] = "deselect-all",
                        ["ctrl-n"] = "down",
                        ["ctrl-p"] = "up",
                        ["ctrl-j"] = "next-history",
                        ["ctrl-k"] = "previous-history",
                    },
                },
            }
        end,
        keys = {
            -- find
            { "<leader><Space>", "<cmd>FzfLua files<CR>", desc = "Find files" },
            { "<leader>fa", "<cmd>FzfLua builtin<CR>", desc = "All pickers" },
            { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Find files" },
            {
                "<leader>f%",
                string.format("<cmd>FzfLua files cwd=%s<CR>", vim.fn.expand "%:p:h"),
                desc = "Find files in directory of current buffer",
            },
            { "<leader>fg", "<cmd>FzfLua live_grep_glob<CR>", desc = "Grep project" },
            {
                "<leader>fw",
                "<cmd>FzfLua grep_cword<CR>",
                desc = "Grep word under cursor",
                mode = { "n", "v" },
            },
            { "<leader>?", "<cmd>FzfLua help_tags<CR>", desc = "Help tags" },
            { "<leader>fc", "<cmd>FzfLua commands<CR>", desc = "Commands" },
            { "<leader>fr", "<cmd>FzfLua oldfiles<CR>", desc = "Recent files" },
            { "<leader>fq", "<cmd>FzfLua quickfix<CR>", desc = "Quickfix" },
            { "<leader>fQ", "<cmd>FzfLua quickfix_stack<CR>", desc = "Quickfix history" },
            { "<leader>`", "<cmd>FzfLua resume<CR>", desc = "Resume last picker" },
            -- buffers
            { "<leader>bb", "<cmd>FzfLua buffers<CR>", desc = "Buffers" },
            {
                "<leader>bg",
                "<cmd>FzfLua lgrep_curbuf<CR>",
                desc = "Grep on current buffer",
            },
            -- git
            { "<leader>gf", "<cmd>FzfLua git_files<CR>", desc = "Git files" },
            { "<leader>gb", "<cmd>FzfLua git_branches<CR>", desc = "Branches" },
            { "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
            { "<leader>gC", "<cmd>FzfLua git_bcommits<CR>", desc = "Buffer commits" },
            { "<leader>gm", "<cmd>FzfLua git_status<CR>", desc = "Modified files" },
            -- lsp
            { "<leader>ld", "<cmd>FzfLua lsp_document_diagnostics<CR>", desc = "Document diagnostics" },
            { "<leader>lD", "<cmd>FzfLua lsp_workspace_diagnostics<CR>", desc = "Workspace diagnostics" },
            { "<leader>ls", "<cmd>FzfLua lsp_document_symbols<CR>", desc = "Document symbols" },
            { "<leader>lS", "<cmd>FzfLua lsp_workspace_symbols<CR>", desc = "Workspace symbols" },
        },
    },
}
