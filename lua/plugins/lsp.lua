return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      eslint = {
        settings = {
          -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
          workingDirectory = { mode = "auto" },
        },
      },
      basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "recommended",
            },
          },
        },
      },
      ruff = {
        cmd_env = { RUFF_TRACE = "messages" },
        init_options = {
          settings = {
            logLevel = "error",
          },
        },
      },
    },
    setup = {
      eslint = function()
        -- automatically fix linting errors on save (but otherwise do not format the document)
        vim.cmd([[
          autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll
        ]])
      end,
    },
  },
}
