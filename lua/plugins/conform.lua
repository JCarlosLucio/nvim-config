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
      },
    },
  },
}
