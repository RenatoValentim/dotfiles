return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    opts = {
      -- debug = true,
      ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
      ---@type Provider
      provider = "copilot",
      auto_suggestions_provider = nil,
      providers = {
        copilot = { model = "claude-3.5-sonnet" },
        ollama = {
          endpoint = "http://localhost:11434",
          model = "llama3:8b", -- llama3:8b | qwen3:4b
        },
      },
    },
    build = "make",
  },
}
