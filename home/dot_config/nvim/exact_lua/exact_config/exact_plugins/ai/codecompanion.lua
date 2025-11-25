return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local default_model = 'anthropic/claude-3.7-sonnet'
    local available_models = {
      'google/gemini-2.0-flash-001',
      'google/gemini-2.5-pro-preview-03-25',
      'anthropic/claude-3.7-sonnet',
      'anthropic/claude-3.5-sonnet',
      'openai/gpt-4o-mini',
    }
    local current_model = default_model

    local function select_model()
      vim.ui.select(available_models, {
        prompt = 'Select  Model:',
      }, function(choice)
        if choice then
          current_model = choice
          vim.notify('Selected model: ' .. current_model)
        end
      end)
    end

    require('codecompanion').setup({
      strategies = {
        chat = {
          adapter = 'openrouter',
        },
        inline = {
          adapter = 'openrouter',
        },
      },
      adapters = {
        http = {
          openrouter = function()
            return require('codecompanion.adapters').extend('openai_compatible', {
              env = {
                url = 'https://openrouter.ai/api',
                api_key = 'cmd:op read "op://Personal/Neovim OpenRouter Key/credential" --no-newline',
                chat_url = '/v1/chat/completions',
              },
              schema = {
                model = {
                  default = current_model,
                },
              },
            })
          end,
        },
      },
      chat = {
        keymaps = {
          send = {
            modes = { n = '<CR>' },
            description = 'Send Chat Message',
            callback = function(chat)
              chat:apply_model(current_model)
              vim.notify('Using model: ' .. current_model)
              chat:submit()
            end,
          },
        },
      },
      extensions = {
        mcphub = {
          callback = 'mcphub.extensions.codecompanion',
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
      },
    })

    vim.keymap.set({ 'n', 'v' }, '<leader>Ck', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true })
    vim.keymap.set({ 'n', 'v' }, '<leader>Ct', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true })
    vim.keymap.set('v', '<leader>Ca', '<cmd>CodeCompanionChat Add<cr>', { noremap = true, silent = true })

    vim.keymap.set('n', '<leader>Cs', select_model, { desc = 'Select Gemini Model' })
    -- Expand 'cc' into 'CodeCompanion' in the command line
    vim.cmd([[cab cc CodeCompanion]])
  end,
}
