require("zk").setup {
    picker = "telescope",
}
local mappings = {
    ["<leader>"] = {
        ["n"] = {
            name = "Notes",
            l = { "<cmd>ZkLinks<CR>", "Zk links" },
            b = { "<cmd>ZkBacklinks<CR>", "Zk backlinks" },
            f = { "<cmd>ZkNotes { sort = { 'modified' } }<CR>", "Zk find notes" },
            c = { "<cmd>ZkCd<CR>", "Zk change directory" },
            t = { "<cmd>ZkTags<CR>", "Zk tags" },
            n = {
                function()
                    vim.ui.input({ prompt = "Title: " }, function(title)
                        if title ~= nil then
                            require("zk").new { title = title }
                        end
                    end)
                end,
                "Zk new",
            },
        },
    },
}
require("which-key").register(mappings, { mode = "n" })
