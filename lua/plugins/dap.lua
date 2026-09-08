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
    local cpp_extensions = { "cpp", "cc", "cxx", "C" }
    local c_extensions = { "c" }

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

    -- Function to run the build task for C/C++
    local function build_and_get_executable_for_current_file()
      local file_dir = vim.fn.expand("%:p:h")
      local filename = vim.fn.expand("%:p")
      local file_base_name = vim.fn.expand("%:t:r")
      local file_ext = vim.fn.expand("%:e")
      local output = file_dir .. "/" .. file_base_name .. ".out"

      local compiler, std_flag
      if vim.tbl_contains(cpp_extensions, file_ext) then
        compiler = "/usr/bin/g++"
        std_flag = "-std=c++23"
      elseif vim.tbl_contains(c_extensions, file_ext) then
        compiler = "/usr/bin/gcc"
        std_flag = "-std=c17"
      else
        vim.notify("Unsupported file type: " .. file_ext, vim.log.levels.ERROR)
        return nil
      end

      -- Build command
      local build_cmd = string.format(
        "cd %s && %s -fdiagnostics-color=always -pedantic-errors -g -Wall -Wextra -Wconversion -Wsign-conversion -Werror %s -ggdb %s -o %s",
        file_dir,
        compiler,
        std_flag,
        filename,
        output
      )

      vim.notify("Building...", vim.log.levels.INFO)
      local result = vim.fn.system(build_cmd)

      if vim.v.shell_error ~= 0 then
        vim.notify("Build failed:\n" .. result, vim.log.levels.ERROR)
        return nil
      end

      vim.notify("Build successful!", vim.log.levels.INFO)
      return output
    end

    local cppSetupCommands = {
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
    }

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
        setupCommands = cppSetupCommands,
      },
      {
        name = "Codelldb: Build & Launch with 'C/C++: g++ build all files for debugging' task", -- requires tasks.json with label "C/C++: g++ build all files for debugging"
        type = "codelldb",
        request = "launch",
        program = "${fileDirname}/${fileBasenameNoExtension}",
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        setupCommands = cppSetupCommands,
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
        setupCommands = cppSetupCommands,
        preLaunchTask = "C/C++: g++ build all files for debugging",
        miDebuggerPath = "/usr/bin/gdb",
      },
      {
        name = "Codelldb: Only Build & Launch current C/C++ file",
        type = "codelldb",
        request = "launch",
        program = build_and_get_executable_for_current_file,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        setupCommands = cppSetupCommands,
      },
    }
    -- Re-use the C++ configuration for C
    dap.configurations.c = dap.configurations.cpp
  end,
}
