-- https://github.com/mfussenegger/nvim-dap
-- Setup gbd via vscode cpptools - https://codeberg.org/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)
-- Dap looks for configurations entries in dap.configurations.<filetype> (https://codeberg.org/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)#configuration)
-- or .vscode/launch.json (https://github.com/mfussenegger/nvim-dap/blob/master/doc/dap.txt#L1409)
-- Example config: https://github.com/igorlfs/dotfiles/blob/main/nvim/.config/nvim/lua/plugins/bare/nvim-dap.lua

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- Runs preLaunchTask / postDebugTask if present
    { "stevearc/overseer.nvim", config = true },
  },
  opts = function()
    local dap = require("dap")
    -- C++ Debug Configuration
    dap.adapters.cppdbg = {
      id = "cppdbg",
      type = "executable",
      -- Requires installation of cpptools extension - https://codeberg.org/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)#installation
      -- Download `cpptools-linux-x63.vsix` from `https://github.com/microsoft/vscode-cpptools/releases`
      -- `unzip cpptools-linux-x63.vsix`
      -- move `extension` directory to `.config/nvim/vscode-extensions/cpptools/`
      -- `mv ./extension ~/.config/nvim/vscode-extensions/cpptools/`
      command = "~/.config/nvim/vscode-extensions/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
    }
  end,
}
