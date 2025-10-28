---@module "lazy"
---@type LazySpec
return {
    "ggandor/leap.nvim",
    lazy = false,
    init = function()
        vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
    end,
    config = function()
        local leap = require "leap"

        vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap-anywhere)')
        vim.keymap.set({'n', 'x', 'o'}, 'gs', function ()
            require('leap.remote').action()
        end)

        -- Define a preview filter to reduce visual noise
        -- and the blinking effect after the first keypress
        -- (`:h leap.opts.preview`). You can still target any visible
        -- positions if needed, but you can define what is considered an
        -- exceptional case.
        -- Exclude whitespace and the middle of alphabetic words from preview:
        --   foobar[baaz] = quux
        --   ^----^^^--^^-^-^--^
        leap.opts.preview = function (ch0, ch1, ch2)
            return not (
                ch1:match('%s')
                or (ch0:match('%a') and ch1:match('%a') and ch2:match('%a'))
            )
        end

        -- Define equivalence classes for brackets and quotes, in addition to
        -- the default whitespace group:
        leap.opts.equivalence_classes = {
            ' \t\r\n', '([{', ')]}', '\'"`'
        }

        -- Use the traversal keys to repeat the previous motion without
        -- explicitly invoking Leap:
        require('leap.user').set_repeat_keys('<enter>', '<backspace>')

        -- remote line(s), with optional count (yaa{leap}, y3aa{leap})
        vim.keymap.set({'x', 'o'}, 'aa', function ()
            -- Force linewise selection.
            local V = vim.fn.mode(true):match('V') and '' or 'V'
            -- In any case, move horizontally, to trigger operations.
            local input = vim.v.count > 1 and (vim.v.count - 1 .. 'j') or 'h'
            -- With `count=false` you can skip feeding count to the command
            -- automatically (we need -1 here, see above).
            require('leap.remote').action { input = V .. input, count = false }
        end)

        -- Create remote versions of all a/i text objects by inserting `r`
        -- into the middle (`iw` becomes `irw`, etc.).
        do
            -- A trick to avoid having to create separate hardcoded mappings for
            -- each text object: when entering `ar`/`ir`, consume the next
            -- character, and create the input from that character concatenated to
            -- `a`/`i`.
            local remote_text_object = function (prefix)
                local ok, ch = pcall(vim.fn.getcharstr)  -- pcall for handling <C-c>
                if not ok or (ch == vim.keycode('<esc>')) then
                    return
                end
                require('leap.remote').action { input = prefix .. ch }
            end

            for _, prefix in ipairs { 'a', 'i' } do
                vim.keymap.set({'x', 'o'}, prefix .. 'r', function ()
                    remote_text_object(prefix)
                end)
            end
        end

        -- 1-character search (enhanced f/t motions)
        do
            -- Return an argument table for `leap()`, tailored for f/t-motions.
            local function as_ft (key_specific_args)
                local common_args = {
                    inputlen = 1,
                    inclusive = true,
                    -- To limit search scope to the current line:
                    -- pattern = function (pat) return '\\%.l'..pat end,
                    opts = {
                        labels = '',  -- force autojump
                        safe_labels = vim.fn.mode(1):match'[no]' and '' or nil, -- [1]
                    },
                }
                return vim.tbl_deep_extend('keep', common_args, key_specific_args)
            end

            local clever = require('leap.user').with_traversal_keys -- [2]
            local clever_f = clever('f', 'F')
            local clever_t = clever('t', 'T')

            for key, key_specific_args in pairs {
                f = { opts = clever_f, },
                F = { backward = true, opts = clever_f },
                t = { offset = -1, opts = clever_t },
                T = { backward = true, offset = 1, opts = clever_t },
            } do
                vim.keymap.set({'n', 'x', 'o'}, key, function ()
                    require('leap').leap(as_ft(key_specific_args))
                end)
            end
        end
        ------------------------------------------------------------------------
        -- [1] Match the modes here for which you don't want to use labels
        --     (`:h mode()`, `:h lua-pattern`).
        -- [2] This helper function makes it easier to set "clever-f"-like
        --     functionality (https://github.com/rhysd/clever-f.vim), returning
        --     an `opts` table derived from the defaults, where the given keys
        --     are added to `keys.next_target` and `keys.prev_target`
    end,
}
