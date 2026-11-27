local ok, leap = pcall(require, "leap")
if not ok then return end

-- vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })

-- TODO: I changed the default labels to remove / from it, but it still shows up,
-- I should try to reproduce it on a minimal config to see if it's a bug a report it.
leap.opts.labels = "sfnjklhodweimbuyvrgtaqpcxzSFNJKLHODWEIMBUYVRGTAQPCXZ?"

-- Define equivalence classes for brackets and quotes, in addition to
-- the default whitespace group:
leap.opts.equivalence_classes = {
    " \t\r\n",
    "([{",
    ")]}",
    "\"`'",
    ":.<>?",
}

-- Jump
vim.keymap.set({ 'n', 'x', 'o' }, 's',  '<Plug>(leap)')
vim.keymap.set('n',               'S',  '<Plug>(leap-from-window)')

--------------------------------------
-- Remote actions (leap.visit-mappings)
--------------------------------------
-- Mnemonic: "get back" (or "boomerang").
-- NOTE: The recommended plug-map from the README <Plug>(leap-visit)
-- automatically starts in Visual mode after you jump (this is also mentioned
-- in the help page), which I don't like. But if you use leap.visit() directly,
-- it won't start in Visual mode.
vim.keymap.set({ 'n', 'x', 'o' }, 'gs', leap.visit)
-- Mnemonic: "remote [text object]".
vim.keymap.set({ 'x', 'o' }, 'ar', '<Plug>(leap-visit-text-object)')
vim.keymap.set({ 'x', 'o' }, 'ir', '<Plug>(leap-visit-inner-text-object)')
-- Useful shortcut for a frequent action (`yrr{leap}` yanks a line
-- right away). See |map-examples| on why the ternary.
vim.keymap.set('o', 'rr', function()
    return (vim.v.count == 0 and '1' or '') .. '<Plug>(leap-visit)'
end, { expr = true })

-- automatic paste on return
vim.api.nvim_create_autocmd('User', {
    pattern = 'VisitDone',
    group = vim.api.nvim_create_augroup('Visit', {}),
    callback = function(event)
        local mode = event.data.mode
        if
            -- Skip if some special register was in use.
            event.data.register == '"'
            -- See |leap.visit-visual|.
            and (mode:match('^[vV\22]') or (vim.v.operator == 'y'))
        then
            vim.cmd('normal! p')
        end
    end,
})

-- Enhanced f/t motions (1-character search)
local function ft(kwargs)
    require('leap').leap(
        vim.tbl_deep_extend('keep', kwargs, {
            inputlen = 1,
            inclusive = true,
            opts = {
                -- Force autojump.
                labels = '',
                -- Match the modes where you don't need labels (`:h mode()`).
                safe_labels = vim.fn.mode(1):match('no?') and '' or nil,
            },
        })
    )
end

-- A helper function making it easier to set "clever-f" behavior
-- (using f/F or t/T instead of ;/, - see the plugin clever-f.vim).
local clever = require('leap.user').with_traversal_keys
local clever_f, clever_t = clever('f', 'F'), clever('t', 'T')

vim.keymap.set({ 'n', 'x', 'o' }, 'f', function()
    ft { opts = clever_f }
end)
vim.keymap.set({ 'n', 'x', 'o' }, 'F', function()
    ft { backward = true, opts = clever_f }
end)
vim.keymap.set({ 'n', 'x', 'o' }, 't', function()
    ft { offset = -1, opts = clever_t }
end)
vim.keymap.set({ 'n', 'x', 'o' }, 'T', function()
    ft { backward = true, offset = 1, opts = clever_t }
end)
