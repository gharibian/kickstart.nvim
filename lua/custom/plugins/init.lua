-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  { -- Render markdown inline in the buffer (aligned tables, styled headers, etc.)
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'markdown' },
    opts = {
      pipe_table = { cell = 'trimmed' },
    },
    config = function(_, opts)
      require('render-markdown').setup(opts)
      -- Code blocks inherit ColorColumn (red here); use a subtle dark grey instead.
      -- Cascades to inline code and code borders (they link to RenderMarkdownCode).
      vim.api.nvim_set_hl(0, 'RenderMarkdownCode', { ctermbg = 234 })
    end,
  },
}
