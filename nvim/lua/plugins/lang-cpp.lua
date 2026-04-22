local mason_clangd = vim.fn.stdpath("data") .. "/mason/bin/clangd"
local clangd_binary = vim.fn.executable(mason_clangd) == 1 and mason_clangd or "clangd"

return {
  -- clangd уже установлен в Mason вручную — не трогаем его, просто добавляем флаги
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          mason = false, -- не переустанавливать, уже есть
          cmd = {
            clangd_binary,
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--header-insertion=iwyu",
          },
        },
      },
    },
  },

  -- clang-format для форматирования C/C++
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "clang-format",
      },
    },
  },
}
