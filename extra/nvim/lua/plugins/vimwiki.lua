return {
  "vimwiki/vimwiki",
  cmd = "VimwikiIndex",
  keys = { { "<leader>ww", "<cmd>VimwikiIndex<cr>", desc = "Open Vimwiki Index" } },
  opts = {
    vimwiki_list = {
      {
        path = "~/vimwiki",
        syntax = "markdown",
        ext = ".md",
      },
    },
  },
}
