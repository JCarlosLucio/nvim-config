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

    --- Function to run the build task for C/C++ for all files or only current file
    ---@param for_current_file (boolean) A flag to know wether to build only for current file
    ---@return (string|nil) The output file path or nil if error
    local function build_executable(for_current_file)
      local file_dir = vim.fn.expand("%:p:h")
      local file_base_name = vim.fn.expand("%:t:r")
      local file_ext = vim.fn.expand("%:e")
      local output = file_dir .. "/" .. file_base_name
      local includes = "-I./source/includes"

      local compiler, std_flag, lang_flags, filename
      if vim.tbl_contains(cpp_extensions, file_ext) then
        compiler = "/usr/bin/g++"
        lang_flags = "-Weffc++"
        std_flag = "-std=c++23"
        filename = "*." .. file_ext
      elseif vim.tbl_contains(c_extensions, file_ext) then
        compiler = "/usr/bin/gcc"
        lang_flags = ""
        std_flag = "-std=c17"
        filename = "*." .. file_ext
      else
        vim.notify("Unsupported file type: " .. file_ext, vim.log.levels.ERROR)
        return nil
      end

      if for_current_file then
        filename = vim.fn.expand("%:p")
        output = output .. ".out"
        includes = ""
      end

      -- Build command
      local build_cmd = string.format(
        "cd %s && %s -fdiagnostics-color=always -pedantic-errors -g -Wall %s -Wextra -Wconversion -Wsign-conversion -Werror %s -ggdb %s -o %s %s",
        file_dir,
        compiler,
        lang_flags,
        std_flag,
        filename,
        output,
        includes
      )

      vim.notify("Building..." .. build_cmd, vim.log.levels.INFO)
      local result = vim.fn.system(build_cmd)

      if vim.v.shell_error ~= 0 then
        vim.notify("Build failed:\n" .. result, vim.log.levels.ERROR)
        return nil
      end

      vim.notify("Build successful!", vim.log.levels.INFO)
      return output
    end

    local function build_executable_for_current_file()
      return build_executable(true)
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
        name = "Codelldb: Build & Launch C/C++ files",
        type = "codelldb",
        request = "launch",
        program = build_executable,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        setupCommands = cppSetupCommands,
        MIMode = "gdb",
        miDebuggerPath = "/usr/bin/gdb",
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
        program = build_executable_for_current_file,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        setupCommands = cppSetupCommands,
        MIMode = "gdb",
        miDebuggerPath = "/usr/bin/gdb",
      },
    }
    -- Re-use the C++ configuration for C
    dap.configurations.c = dap.configurations.cpp
  end,
}
