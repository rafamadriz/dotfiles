local M = {}

M.config = {
    winopts = {
        height = 0.45, -- window height
        width = 0.55, -- window width
        row = 0.35, -- window row position (0=top, 1=bottom)
        col = 0.50, -- window col position (0=left, 1=right)
        preview = {
            hidden = "hidden",
            layout = "vertical",
        },
    },
    fzf_opts = {
        ["--history"] = vim.fn.stdpath "data" .. "/fzf-lua-history",
    },
    files = {
        formatter = "path.filename_first",
        fzf_opts = {
            ["--history"] = vim.fn.stdpath "data" .. "/fzf-lua-files-history",
        },
        cwd_prompt = false,
    },
    grep = {
        -- debug = true,
        formatter = "path.filename_first",
        winopts = {
            width = 0.8, -- window width
        },
        rg_glob = true,
        rg_opts = [[--column --hidden --glob "!**/.git/**" ]]
            .. [[--line-number --no-heading --color=always ]]
            .. [[--smart-case --max-columns=4096 -e]],
        fzf_opts = {
            ["--history"] = vim.fn.stdpath "data" .. "/fzf-lua-grep-history",
        },
        -- first returned string is the new search query
        -- second returned string are (optional) additional rg flags
        -- @return string, string?
        rg_glob_fn = function(query, _)
            local regex, flags = query:match "^(.-)%s%-%-(.*)$"
            -- If no separator is detected will return the original query
            return (regex or query), flags
        end,
    },
    keymap = {
        fzf = {
            ["ctrl-q"] = "select-all+accept",
            ["alt-a"] = "toggle-all",
            ["ctrl-n"] = "down",
            ["ctrl-p"] = "up",
            ["ctrl-j"] = "next-history",
            ["ctrl-k"] = "previous-history",
        },
    },
}

M.keymaps = {
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
    { "<leader>bg", "<cmd>FzfLua lgrep_curbuf<CR>", desc = "Grep on current buffer" },
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
}

return {
    {
        "ibhagwan/fzf-lua",
        cmd = { "FzfLua" },
        config = function() require("fzf-lua").setup(M.config) end,
        keys = M.keymaps,
    },
}
