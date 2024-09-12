return {
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    event = "VeryLazy"
  },
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "jremmen/vim-ripgrep",
      "nvim-telescope/telescope-fzf-native.nvim"
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            }
          }
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          }
        }
      })

      telescope.load_extension("fzf")

      local builtin = require("telescope.builtin")

      vim.keymap.set("n", "<C-p>", builtin.find_files, { noremap = true })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { noremap = true })
      vim.keymap.set("n", "<leader>h", builtin.oldfiles, { noremap = true })
    end
  }
}
