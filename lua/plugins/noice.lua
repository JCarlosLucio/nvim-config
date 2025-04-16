return {
  "folke/noice.nvim",
  opts = function(_, opts)
    -- hide "No information available" notifications
    table.insert(opts.routes, {
      filter = {
        event = "notify",
        find = "No information available",
      },
      opts = { skip = true },
    })
  end,
}
