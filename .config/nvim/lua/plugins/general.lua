-- kommentary
require("kommentary.config").use_extended_mappings()

-- Colorizer
require "colorizer".setup(
    {"*"},
    {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true -- Enable all CSS *functions*: rgb_fn, hsl_fn
    }
)

-- Autopairs
if Completion.autopairs == nil or Completion.autopairs == true then
    require("nvim-autopairs").setup()
    local remap = vim.api.nvim_set_keymap
    local npairs = require("nvim-autopairs")

    -- skip it, if you use another global object
    _G.MUtils = {}

    vim.g.completion_confirm_key = ""
    MUtils.completion_confirm = function()
        if vim.fn.pumvisible() ~= 0 then
            if vim.fn.complete_info()["selected"] ~= -1 then
                vim.fn["compe#confirm"]()
                return npairs.esc("")
            else
                vim.api.nvim_select_popupmenu_item(0, false, false, {})
                vim.fn["compe#confirm"]()
                return npairs.esc("<c-n>")
            end
        else
            return npairs.check_break_line_char()
        end
    end

    remap("i", "<CR>", "v:lua.MUtils.completion_confirm()", {expr = true, noremap = true})
end

-- Git signs
require("gitsigns").setup {
    signs = {
        -- TODO add hl to colorscheme
        add = {hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn"},
        change = {hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn"},
        delete = {hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn"},
        topdelete = {hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn"},
        changedelete = {hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn"}
    },
    numhl = false,
    linehl = false,
    keymaps = {
        -- Default keymap options
        noremap = true,
        buffer = true
    },
    watch_index = {
        interval = 1000
    },
    sign_priority = 6,
    update_debounce = 200,
    status_formatter = nil, -- Use default
    use_decoration_api = false
}
