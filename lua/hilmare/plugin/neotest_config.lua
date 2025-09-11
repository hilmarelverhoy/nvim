require("neotest").setup({
  adapters = {
    require("neotest-dotnet")({
      dap = { justMyCode = false },
    }),
  },
})
