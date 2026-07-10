-- nvim-dap config
-- https://codeberg.org/mfussenegger/nvim-dap
-- Dap looks for configurations entries in dap.configurations.<filetype>
-- or .vscode/launch.json (https://github.com/mfussenegger/nvim-dap/blob/master/doc/dap.txt#L1409)

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- Runs preLaunchTask / postDebugTask if present
    { "stevearc/overseer.nvim", config = true },
  },
  opts = function()
    local dap = require("dap")

    -- Function to run the build task for C++
    local function build_and_get_executable()
      local file_dir = vim.fn.expand("%:p:h")
      local file_base_name = vim.fn.expand("%:t:r")

      -- Build command matching tasks.json for debugging task
      local build_cmd = string.format(
        "cd %s && /usr/bin/g++ -fdiagnostics-color=always -pedantic-errors -g -Wall -Weffc++ -Wextra -Wconversion -Wsign-conversion -Werror -std=c++23 -ggdb *.cpp -o %s -I./source/includes",
        file_dir,
        file_base_name
      )

      vim.notify("Building...", vim.log.levels.INFO)
      local result = vim.fn.system(build_cmd)

      if vim.v.shell_error ~= 0 then
        vim.notify("Build failed:\n" .. result, vim.log.levels.ERROR)
        return nil
      end

      vim.notify("Build successful!", vim.log.levels.INFO)
      return file_dir .. "/" .. file_base_name
    end

    dap.configurations.cpp = {
      -- C/C++ Debug Configuration via codelldb(codelldb installed via mason)
      -- https://codeberg.org/mfussenegger/nvim-dap/wiki/C-CPP-Rust-%28via-codelldb%29#configuration
      {
        name = "Codelldb: Build & Launch",
        type = "codelldb",
        request = "launch",
        program = build_and_get_executable,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        setupCommands = {
          {
            description = "Enable pretty-printing for gdb",
            text = "-enable-pretty-printing",
            ignoreFailures = true,
          },
          {
            description = "Set Disassembly Flavor to Intel",
            text = "-gdb-set disassembly-flavor intel",
            ignoreFailures = true,
          },
        },
      },
      {
        name = "Codelldb: Build & Launch with 'C/C++: g++ build all files for debugging' task", -- requires tasks.json with label "C/C++: g++ build all files for debugging"
        type = "codelldb",
        request = "launch",
        program = "${fileDirname}/${fileBasenameNoExtension}",
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        setupCommands = {
          {
            description = "Enable pretty-printing for gdb",
            text = "-enable-pretty-printing",
            ignoreFailures = true,
          },
          {
            description = "Set Disassembly Flavor to Intel",
            text = "-gdb-set disassembly-flavor intel",
            ignoreFailures = true,
          },
        },
        preLaunchTask = "C/C++: g++ build all files for debugging",
      },
      -- C/C++ Debug Configuration via vscode-cpptools(cpptools installed via mason)
      -- https://codeberg.org/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)#configuration
      {
        name = "Cppdbg: Build & Debug active file with 'C/C++: g++ build all files for debugging' task (waiting for cpptools update) ", -- requires tasks.json with label "C/C++: g++ build all files for debugging"
        type = "cppdbg",
        request = "launch",
        program = "${fileDirname}/${fileBasenameNoExtension}",
        args = {},
        stopAtEntry = false,
        cwd = "${fileDirname}",
        environment = {},
        externalConsole = false,
        MIMode = "gdb",
        setupCommands = {
          {
            description = "Enable pretty-printing for gdb",
            text = "-enable-pretty-printing",
            ignoreFailures = true,
          },
          {
            description = "Set Disassembly Flavor to Intel",
            text = "-gdb-set disassembly-flavor intel",
            ignoreFailures = true,
          },
        },
        preLaunchTask = "C/C++: g++ build all files for debugging",
        miDebuggerPath = "/usr/bin/gdb",
      },
    }

    -- Re-use the C++ configuration for C
    dap.configurations.c = dap.configurations.cpp
  end,
}
