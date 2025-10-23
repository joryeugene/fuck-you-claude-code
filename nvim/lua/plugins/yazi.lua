-- yazi.lua - File explorer integration

return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>e",
      "<cmd>Yazi<cr>",
      desc = "Open yazi",
    },
  },
  opts = {
    open_for_directories = false,
  },
}
