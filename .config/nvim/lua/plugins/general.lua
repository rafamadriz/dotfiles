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

-- kommentary
require("kommentary.config").use_extended_mappings()

-- Autopairs
require("nvim-autopairs").setup()

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

-- Emmet
vim.g.user_emmet_mode = "inv"
vim.g.user_emmet_expandabbr_key = ",,"
vim.g.user_emmet_expandword_key = "<C-y>;"
vim.g.user_emmet_update_tag = "<C-y>u"
vim.g.user_emmet_balancetaginward_key = "<C-y>d"
vim.g.user_emmet_balancetagoutward_key = "<C-y>D"
vim.g.user_emmet_next_key = "<C-y>n"
vim.g.user_emmet_prev_key = "<C-y>N"
vim.g.user_emmet_imagesize_key = "<C-y>i"
vim.g.user_emmet_togglecomment_key = "<C-y>/"
vim.g.user_emmet_splitjointag_key = "<C-y>j"
vim.g.user_emmet_removetag_key = "<C-y>k"
vim.g.user_emmet_anchorizeurl_key = "<C-y>a"
vim.g.user_emmet_anchorizesummary_key = "<C-y>A"
vim.g.user_emmet_mergelines_key = "<C-y>m"
vim.g.user_emmet_codepretty_key = "<C-y>c"
