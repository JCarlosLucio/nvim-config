return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      -- "~/.local/share/nvim/lazy/",
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      { path = "LazyVim", words = { "LazyVim" } },
      { path = "snacks.nvim", words = { "Snacks" } },
      { path = "lazy.nvim", words = { "LazyVim" } },
    },
  },
}
