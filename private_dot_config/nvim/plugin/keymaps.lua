local map = vim.keymap.set

-- Move by visible lines, fixes annoying behavior on wrapped lines
map({ "n", "x" }, "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true })
map({ "n", "x" }, "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true })

map("n", "<BS>", "<C-^>",    { desc = "Jump between last two buffers" })
map({ "n", "v" }, "H", "^",  { desc = "Go to first character of line" })
map({ "n", "v" }, "L", "g_", { desc = "Go to last character of line" })

-- TODO: remove mbbill/undotree and enable this on 0.12
-- map("n", "<leader>u", ":Undotree<CR>", { desc = "undotree" })
map("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "undotree" })

-- terminal
map("t", [[<C-\>]], [[<C-\><C-n>]], { desc = "Enter normal mode in terminal" })

-- Disable repeat last recorded character
map("n", "Q", "<Nop>")

-- visual
map( "n", "gV", [["`[" . strpart(getregtype(), 0, 1) . "`]"]], { expr = true, desc = "Reselect latest changed, put or yanked text" })
map("x", "/", "<esc>/\\%V",                                    { silent = false, desc = "Search inside visual selection" })

-- Fix annoying behavior where for example: If in blockwise visual mode
-- and add some text through multiple lines, I would end with <C-c>
-- (out of muscle memory), but this cancels whatever I did and have to do it again
-- source: https://github.com/neovim/neovim/issues/16416
map("i", "<C-c>", "<C-c>")

-- Kinda of smooth scrolling. See :help scroll-smooth
map("n", "<C-U>", "<C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y>")
map("n", "<C-D>", "<C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E>")

-- Copy/paste with system clipboard
map({ "n", "x", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
map("n", "<leader>Y", [["+y$]],              { desc = "Yank to system clipboard (end of line)" })
map("n", "<leader>p", [["+p`[v`]=]],         { desc = "Paste from system clipboard" })
map("n", "<leader>P", [["+P]],               { desc = "Paste from system clipboard" })
-- Paste in Visual with `P` to not copy selected text (`:h v_P`)
map("x", "<leader>p", [["+P]],               { desc = "Paste from system clipboard" })

-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
map({ "t", "i" }, "<A-h>", "<C-\\><C-n><C-w>h")
map({ "t", "i" }, "<A-j>", "<C-\\><C-n><C-w>j")
map({ "t", "i" }, "<A-k>", "<C-\\><C-n><C-w>k")
map({ "t", "i" }, "<A-l>", "<C-\\><C-n><C-w>l")
map({ "n" }, "<A-h>", "<C-w>h")
map({ "n" }, "<A-j>", "<C-w>j")
map({ "n" }, "<A-k>", "<C-w>k")
map({ "n" }, "<A-l>", "<C-w>l")

-- Save and delete buffers
map("n", "<leader>w", ":update<CR>",                               { desc = "Write buffer" })
map("v", "<leader>w", "<ESC>:update<CR>gv",                        { desc = "Write buffer" })
map("n", "<leader>q", ":bdelete<CR>",                              { desc = "Quit buffer" })
map("n", "<leader>Q", ":write | silent %bd | silent e# | bd#<CR>", { desc = "Quit all buffers but current" })
map("n", "<leader>!", ":noautocmd write<CR>",                      { desc = "Save noautocmd" })

-- Easier builtin completion
map("i", "<c-space>", "<C-X><C-O>")
map("i", "<C-F>", "<C-X><C-F>")
map("i", "<C-L>", "<C-X><C-L>")

-- Use `<C-g>u` in Insert mode to mark this as separate undoable action.
-- Source: https://stackoverflow.com/a/16481737
-- NOTE: this remaps `<C-z>` in Normal mode (completely stops Neovim)
map("n", "<C-Z>", "[s1z=",                     { desc = "Correct latest misspelled word" })
map("i", "<C-Z>", "<C-g>u<Esc>[s1z=`]a<C-g>u", { desc = "Correct latest misspelled word" })

map("v", "<", "<gv", { desc = "Keep visual selection when indenting to left" })
map("v", ">", ">gv", { desc = "Keep visual selection when indenting to right" })

-- Make sure to go to proper indentation level when pressing i
-- source: https://www.reddit.com/r/neovim/comments/12rqyl8/5_smart_minisnippets_for_making_text_editing_more/
map("n", "i", function()
    if #vim.fn.getline "." == 0 then
        return [["_cc]]
    else
        return "i"
    end
end, { expr = true })

-- I always type :Q by mistake
vim.api.nvim_create_user_command("Q", function(arg)
    if arg.bang then
        vim.cmd.quit { bang = true }
    else
        vim.cmd.quit()
    end
end, { bang = true })

-- I always type :W by mistake
vim.api.nvim_create_user_command("W", function(arg)
    if arg.bang then
        vim.cmd.write { bang = true }
    else
        vim.cmd.update()
    end
end, { bang = true })

vim.api.nvim_create_user_command("RemoveTrailing", function()
    local pos = vim.api.nvim_win_get_cursor(0)

    -- delete trailing whitespace
    vim.cmd [[:keepjumps keeppatterns %s/\s\+$//e]]

    -- delete lines at eof
    vim.cmd [[:keepjumps keeppatterns silent! 0;/^\%(\n*.\)\@!/,$d_]]

    local num_rows = vim.api.nvim_buf_line_count(0)

    --[[
            if the row value in the original cursor
            position tuple is greater than the
            line count after empty line deletion
            (meaning that the cursor was inside of
            the group of empty lines at the end of
            the file when they were deleted), set
            the cursor row to the last line.
        ]]
    if pos[1] > num_rows then
        pos[1] = num_rows
    end

    vim.api.nvim_win_set_cursor(0, pos)
end, {})

-- Resize windows
-- expand or minimize current buffer in "actual" direction
-- this is useful as mapping ":resize 2" stand-alone might otherwise not be in
-- the right direction if mapped to ctrl-left arrow or something related use
local resize = function(vertical, margin)
    local cmd = vim.cmd
    local cur_win = vim.api.nvim_get_current_win()
    -- go (possibly) right
    cmd(string.format("wincmd %s", vertical and "l" or "j"))
    local new_win = vim.api.nvim_get_current_win()

    -- determine direction cond on increase and existing right-hand buffer
    local not_last = not (cur_win == new_win)
    local sign = margin > 0
    -- go to previous window if required otherwise flip sign
    if not_last == true then
        cmd [[wincmd p]]
    else
        sign = not sign
    end

    local symbol = sign and "+" or "-"
    local dir = vertical and "vertical " or ""
    local _cmd = dir .. "resize " .. symbol .. math.abs(margin) .. "<CR>"
    cmd(_cmd)
end

map({ "n", "t" }, "<C-Up>",    function() resize(false, -2) end, { desc = "Resize up window horizontally" })
map({ "n", "t" }, "<C-Down>",  function() resize(false, 2) end,  { desc = "Resize down window horizontally" })
map({ "n", "t" }, "<C-Left>",  function() resize(true,  -2) end, { desc = "Resize left window vertically" })
map({ "n", "t" }, "<C-Right>", function() resize(true,  2) end,  { desc = "Resize right window vertically" })

------------------------------
------- Plugins Keymaps ------
------------------------------
-- FZF
map("n", "<leader><leader>", function()
    local current_buffer = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
    local is_oil_buffer = vim.startswith(current_buffer, "oil://")
    if is_oil_buffer then
        vim.cmd(string.format("FzfLua files cwd=%s", require("oil").get_current_dir()))
        return
    end
    vim.cmd "FzfLua global"
end, { desc = "find global" })
map("n", "<leader>`",  ":FzfLua resume<CR>",      { desc = "picker resume" })
map("n", "<leader>fa", ":FzfLua builtin<CR>",     { desc = "all pickers" })
map("n", "<leader>?",  ":FzfLua helptags<CR>",    { desc = "help tags" })
map("n", "<leader>fq", ":FzfLua quickfix<CR>",    { desc = "quickfix" })
map("n", "<leader>fg", ":FzfLua live_grep<CR>",   { desc = "grep live" })
map("n", "<leader>fw", ":FzfLua grep_cword<CR>",  { desc = "grep cword" })
map("v", "<leader>fv", ":FzfLua grep_visual<CR>", { desc = "grep visual" })
map("n", "<leader>fp", ":FzfLua grep<CR>",        { desc = "grep pattern" })
map("n", "<leader>fd", function()
    vim.ui.input(
        { prompt = "path to directory (leave empty for directory of current file): ", completion = "dir" },
        function(path)
            if not path then
                return
            end
            if path == "" then
                local filename = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
                path = vim.fn.fnamemodify(filename, ":p:h")
            end
            vim.cmd(string.format("FzfLua files cwd=%s", path))
        end
    )
end, { desc = "find files in directory" })
-- git
map("n", "<leader>gC", ":FzfLua git_commits<CR>",               { desc = "commits" })
map("n", "<leader>gc", ":FzfLua git_bcommits<CR>",              { desc = "buffer commits" })
-- lsp
map("n", "<leader>ld", ":FzfLua lsp_document_diagnostics<CR>",  { desc = "document diagnostics" })
map("n", "<leader>lD", ":FzfLua lsp_workspace_diagnostics<CR>", { desc = "workspace diagnostics" })
map("n", "<leader>ls", ":FzfLua lsp_document_symbols<CR>",      { desc = "document symbols" })
map("n", "<leader>lS", ":FzfLua lsp_workspace_symbols<CR>",     { desc = "workspace symbols" })
