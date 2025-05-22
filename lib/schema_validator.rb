class SchemaValidator
  class ValidationError < StandardError; end

  def self.validate(data, schema)
    # Validate object type
    unless schema[:type] == :object
      raise ValidationError, "Schema must be of type :object"
    end

    # Check required fields
    schema[:required]&.each do |field|
      if data[field].nil?
        raise ValidationError, "Missing required field: #{field}"
      end
    end

    # Validate properties
    schema[:properties]&.each do |field, rules|
      value = data[field]
      next if value.nil? && !schema[:required]&.include?(field)

      # Type checking
      if rules[:type]
        case rules[:type]
        when :string
          unless value.is_a?(String)
            raise ValidationError, "Invalid type for #{field}: expected String, got #{value.class}"
          end
          # Add other type checks as needed
        end
      end

      # Format validation
      if value && rules[:format] && !(value =~ rules[:format])
        raise ValidationError, "Invalid format for #{field}"
      end
    end

    data
  end
end
