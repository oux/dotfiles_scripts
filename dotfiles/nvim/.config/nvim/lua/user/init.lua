-- TODO:
-- highlight TODO
-- cut word keep clipboard
-- external command to open file
return {
  colorscheme = "tokyonight",
  -- colorscheme = "tokyonight-moon",
  highlights = {
    tokyonight = {
      Normal = {bg = "none" },
      NormalNC = { bg = "#000000" },
    },
    init = {
      Normal = { bg = "none" },
      NormalNC = { bg = "#000000" },
    }
  },
  mappings = {
    i = {
      ["<home>"] = {
        function ()
          local _,c = unpack(vim.api.nvim_win_get_cursor(0))
          vim.cmd('norm! ^')
          local _,c2 = unpack(vim.api.nvim_win_get_cursor(0))
          if c == c2 then
            vim.cmd('norm! 0')
          end
        end,
        desc = "Toggle foldcolumn + number + signcolumn"
      },
    },
    n = {
      ["<home>"] = {
        function ()
          local _,c = unpack(vim.api.nvim_win_get_cursor(0))
          vim.cmd('norm! ^')
          local _,c2 = unpack(vim.api.nvim_win_get_cursor(0))
          if c == c2 then
            vim.cmd('norm! 0')
          end
        end,
        desc = "Toggle foldcolumn + number + signcolumn"
      },
      ["ù"] = "<cmd>lua require('telescope.builtin').oldfiles{}<CR>",
      ["<leader>a"] = {
        function ()
          local ui = require("astronvim.utils.ui")
          ui.toggle_signcolumn(true)
          if vim.wo.number then
            vim.wo.number = false
            vim.wo.foldcolumn = "0"
            vim.wo.signcolumn = "no"
            require("astronvim.utils").notify("Hidding details")
          else
            vim.wo.number = true
            vim.wo.foldcolumn = "1"
            vim.wo.signcolumn = "yes"
            require("astronvim.utils").notify("Display details")
          end
        end,
        desc = "Toggle foldcolumn + number + signcolumn"
      },
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
      scrolloff = 5,
    },
    g = {
      mapleader = ';',
    },
  },
}

