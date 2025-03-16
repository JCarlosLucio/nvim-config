return {
  "nvim-neotest/neotest",
  dependencies = {
    "marilari88/neotest-vitest",
    "thenbe/neotest-playwright",
  },
  opts = {
    adapters = {
      ["neotest-vitest"] = {
        -- Filter directories - https://github.com/marilari88/neotest-vitest?tab=readme-ov-file#filter-directories
        filter_dir = function(rel_path)
          if rel_path:match("^e2e") then
            return false
          else
            return true
          end
        end,
      },
      ["neotest-playwright"] = {
        options = {
          persist_project_selection = true,
          enable_dynamic_test_discovery = true,
          preset = "headed",
          -- Filter Test Files - https://github.com/thenbe/neotest-playwright?tab=readme-ov-file#configuration
          is_test_file = function(file_path)
            -- local result = file_path:find("%.spec%.[tj]sx?$") ~= nil -- Match files ending in *.spec.[js|ts|jsx|tsx]
            local result = file_path:find("e2e/.*%.spec%.[tj]sx?$") ~= nil -- Match files with e2e/*.spec.[js|ts|jsx|tsx]
            return result
          end,
        },
      },
    },
  },
}
