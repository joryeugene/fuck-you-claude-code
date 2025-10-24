-- vim-illuminate - Automatically highlight word under cursor
-- Shows all occurrences of the word/symbol under cursor

return {
  "RRethy/vim-illuminate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    providers = {
      "lsp",
      "treesitter",
      "regex",
    },
    delay = 100, -- delay in milliseconds before highlighting
    filetype_overrides = {},
    filetypes_denylist = {
      "dirvish",
      "fugitive",
      "neo-tree",
      "dashboard",
      "Avante",
      "AvanteInput",
      "Trouble",
      "trouble",
      "lazy",
      "mason",
    },
    filetypes_allowlist = {},
    modes_denylist = {},
    modes_allowlist = {},
    providers_regex_syntax_denylist = {},
    providers_regex_syntax_allowlist = {},
    under_cursor = true, -- whether or not to illuminate under the cursor
    large_file_cutoff = nil, -- number of lines at which to use large_file_config
    large_file_overrides = nil, -- config to use for large files
    min_count_to_highlight = 1, -- minimum number of matches required to highlight
  },
  config = function(_, opts)
    require("illuminate").configure(opts)

    -- Custom keymaps for jumping between references
    vim.keymap.set("n", "]]", function()
      require("illuminate").goto_next_reference(false)
    end, { desc = "Next reference (illuminate)" })

    vim.keymap.set("n", "[[", function()
      require("illuminate").goto_prev_reference(false)
    end, { desc = "Previous reference (illuminate)" })
  end,
}
