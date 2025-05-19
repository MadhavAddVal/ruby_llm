RubyLLM.configure do |config|
  config.openai_api_key = Rails.application.credentials.openrouter_api_key
  config.openai_api_base = "https://openrouter.ai/api/v1"
  config.default_model = "gpt-3.5-turbo"
end
