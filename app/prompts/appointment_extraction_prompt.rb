class AppointmentExtractionPrompt
  PROMPT = <<~PROMPT
    You are a medical appointment assistant. Extract the following information from the user's text:
    - Patient name
    - Phone number
    - Medical condition
    - Preferred doctor (if mentioned)
    - Preferred appointment time (if mentioned)

    Format the output as a JSON object with these fields. If any field is not found, use null.

    User text: {{user_text}}

    Respond only with valid JSON. Example format:
    {
      "patient_name": "John Doe",
      "phone_number": "+1234567890",
      "condition": "headache",
      "doctor_name": "Dr. Smith"
    }
  PROMPT
end
