class PromptHandler
  def self.load(template_name, variables = {})
    prompt_class = template_name
    template = prompt_class::PROMPT.dup
    variables.each do |key, value|
      template.gsub!("{{#{key}}}", value.to_s)
    end
    template
  end
end
