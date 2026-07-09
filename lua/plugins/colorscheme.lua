return {
  "folke/tokyonight.nvim",
  opts = {
    style = "moon", -- "moon", "storm", "night", "day"
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
  },
}
--
-- return {
--   "maxmx03/fluoromachine.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require("fluoromachine").setup({
--       theme = "delta", -- "delta", "retrowave", "fluoromachine"
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
--       palette = "default", -- "default", "darker", "minimal"
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
-- return {
--   "EdenEast/nightfox.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require("nightfox").setup({
--       options = {
--         transparent = true,
--         dim_inactive = false,
--         styles = {
--           comments = "italic",
--           keywords = "bold",
--           types = "italic,bold",
--         },
--       },
--     })
--     vim.cmd("colorscheme duskfox") -- or nightfox nordfox terafox carbonfox
--   end,
-- }
