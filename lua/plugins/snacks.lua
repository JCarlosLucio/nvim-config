return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      hidden = true, -- for hidden files in explorer
      ignored = true, -- for .gitignore files in explorer
      exclude = { ".git" }, -- for excluding .git dir in explorer
      sources = {
        files = {
          hidden = true, -- for hidden files in File Finder
          ignored = true, -- for .gitignore files in File Finder
        },
      },
    },
  },
}
