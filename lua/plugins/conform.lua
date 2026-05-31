---@module "conform"

return {
  {
    "stevearc/conform.nvim",
    ---@type conform.setupOpts
    opts = {
      -- https://docs.astral.sh/ruff/editors/setup/#neovim
      formatters_by_ft = {
        python = {
          "ruff_fix",
          "ruff_format",
          "ruff_organize_imports",
        },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
      -- Don't set `opts.format_on_save` for `conform.nvim`.
      -- LazyVim will use the conform formatter automatically
      --
      -- format_on_save = {
      --   timeout_ms = 500,
      --   lsp_format = "fallback",
      --   async = false,
      -- },
    },
  },
}
