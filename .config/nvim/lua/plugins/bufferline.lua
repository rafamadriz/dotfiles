require "bufferline".setup {
    options = {
        view = "multiwindow",
        numbers = "ordinal",
        number_style = "superscript",
        --mappings = true | false,
        buffer_close_icon = "",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 18,
        max_prefix_length = 15, -- prefix used when a buffer is deduplicated
        tab_size = 18,
        diagnostics = "nvim_lsp",
        --    show_buffer_close_icons = true | false,
        --    show_close_icon = true | false,
        show_tab_indicators = true,
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        -- can also be a table containing 2 custom separators
        -- [focused and unfocused]. eg: { '|', '|' }
        separator_style = "thick"
        --    enforce_regular_tabs = false | true,
        --    always_show_bufferline = true | false,
        --sort_by = 'extension' | 'relative_directory' | 'directory' | function(buffer_a, buffer_b)
        -- add custom logic
    }
}
