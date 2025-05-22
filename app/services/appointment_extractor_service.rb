require "json"

class AppointmentExtractorService
  def initialize
    @llm = RubyLLM.chat
  end

  def extract(text)
    prompt = PromptHandler.load(AppointmentExtractionPrompt, user_text: text)
    response = @llm.ask(prompt)

    begin
      data = JSON.parse(response.content, symbolize_names: true)
      validate_appointment_data(data)
      data
    rescue JSON::ParserError => e
      raise "Failed to parse LLM response as JSON: #{e.message}"
    rescue SchemaValidator::ValidationError => e
      raise "Schema validation error: #{e.message}"
    end
  end

  def validate_appointment_data(data)
    schema = {
      "type" => "object",
      "required" => [ "patient_name", "phone_number", "condition", "doctor_name" ],
      "properties" => {
        "patient_name" => { "type" => "string" },
        "phone_number" => { "type" => "string" },
        "condition" => { "type" => "string" },
        "doctor_name" => { "type" => "string" },
        "appointment_time" => { "type" => [ "string", "null" ] }
      }
    }
    schema_validator = JSONSchemer.schema(schema)
    errors = schema_validator.validate(data).to_a
    if errors.any?
      raise "Invalid appointment data: #{errors.first}"
    end
  end
end
