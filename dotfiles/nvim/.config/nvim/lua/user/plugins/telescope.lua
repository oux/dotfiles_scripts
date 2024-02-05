return {
  "nvim-telescope/telescope.nvim",
  opts = function()
    local actions = require "telescope.actions"
    return {
      pickers = {
        colorscheme = {
          enable_preview = false,
          preview_cutoff = 1,
          layout_config = {
            width = 0.20,
            height = 0.40,
          },
        },
      },
      defaults = {
        layout_config = {
          horizontal = { prompt_position = "bottom" },
          width = 0.90,
          height = 0.90,
        },
        mappings = {
          i = {
            ["<C-k>"] = actions.preview_scrolling_up,
            ["<C-j>"] = actions.preview_scrolling_down,
            ["<C-h>"] = actions.preview_scrolling_left,
            ["<C-l>"] = actions.preview_scrolling_right,
          },
        },
      },
    }
  end,
}
