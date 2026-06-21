if not vim.pack.is_installed "nvim-treesitter" then
    return
end

vim.api.nvim_create_autocmd('User', { pattern = 'TSUpdate',
    callback = function()
        require"nvim-treesitter.parsers".qf = {
            install_info = {
                url = "https://github.com/OXY2DEV/tree-sitter-qf",
                branch = "main",
                queries = "queries/"
            },
        }
    end
})

local ts = require "nvim-treesitter"

local parsers = {
    "bash",
    "c",
    "comment",
    "cpp",
    "css",
    "diff",
    "gitcommit",
    "go",
    "html",
    "http",
    "javascript",
    "json",
    "jsx",
    "lua",
    "luadoc",
    "luap",
    "markdown",
    "markdown_inline",
    "python",
    "qf",
    "query",
    "regex",
    "rust",
    "scss",
    "todotxt",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
    "zig",
}

local function get_parsers_to_install()
    local installed = ts.get_installed()
    local not_installed = {}

    for _, parser in pairs(parsers) do
        if not vim.tbl_contains(installed, parser) then
            table.insert(not_installed, parser)
        end
    end

    return not_installed
end

ts.install(get_parsers_to_install())

local installed = {}
for _, lang in ipairs(ts.get_installed()) do
    installed[lang] = true
end

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local ft = vim.bo[args.buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)

        if not installed[lang] then
            return
        end

        -- indentation, provided by nvim-treesitter
        vim.treesitter.start(args.buf, lang)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        -- treesitter based folding
        vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
})
