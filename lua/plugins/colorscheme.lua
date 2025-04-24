return {
  "folke/tokyonight.nvim",
  opts = {
    style = "night", -- "moon", "storm", "night", "day"
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
  },
}

-- return {
--   "maxmx03/fluoromachine.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require("fluoromachine").setup({
--       theme = "delta",
--       glow = true,
--       transparent = true,
--     })
--
--     vim.cmd.colorscheme("fluoromachine")
--   end,
-- }
--
-- return {
--   "eldritch-theme/eldritch.nvim",
--   lazy = false,
--   priority = 1000,
--   opts = {},
--   config = function()
--     require("eldritch").setup({
--       transparent = true,
--       palette = "default",
--     })
--     vim.cmd("colorscheme eldritch")
--   end,
-- }
--
-- return {
--   {
--     "scottmckendry/cyberdream.nvim",
--     lazy = false,
--     priority = 1000,
--     config = function()
--       require("cyberdream").setup({
--         transparent = true,
--         italic_comments = true,
--         -- hide_fillchars = true,
--         borderless_telescope = false,
--         terminal_colors = true,
--       })
--       vim.cmd("colorscheme cyberdream")
--     end,
--   },
-- }
--
