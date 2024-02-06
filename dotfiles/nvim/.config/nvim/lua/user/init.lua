return {
  colorscheme = "tokyonight",
  -- colorscheme = "tokyonight-moon",
  highlights = {
    tokyonight = {
      Normal = { bg = "none" },
      NormalNC = { bg = "#000000" },
    },
    init = {
      Normal = { bg = "none" },
      NormalNC = { bg = "#000000" },
    }
  },
  mappings = {
    n = {
      ["ù"] = "<cmd>lua require('telescope.builtin').oldfiles{}<CR>",
      ["<leader>s"] = {
        function()
          require("telescope.builtin").live_grep {
            additional_args = function(args) return vim.list_extend(args, { "-L", "--hidden", "--no-ignore" }) end,
          }
        end,
        desc = "Find words in all files (following symlinks)",
      },
    },
  },
  options = {
    opt = {
      relativenumber = false,
      number = true,
    },
    g = {
      mapleader = ';',
    },
  },
}

