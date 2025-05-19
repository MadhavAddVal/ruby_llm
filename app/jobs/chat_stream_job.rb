class ChatStreamJob < ApplicationJob
  queue_as :default

  def perform(chat_id, user_content)
    chat = Chat.find(chat_id)

    # Create assistant message before streaming starts
    assistant_message = chat.messages.create!(
      role: :assistant,
      content: "",  # Initialize with empty content
      model_id: chat.model_id,
    )

    begin
      # Initialize RubyLLM chat instance
      llm_chat = RubyLLM.chat

      # Send request and handle streaming response
      response = llm_chat.ask(user_content) do |chunk|
        if chunk.content.present?
          current_content = assistant_message.content || ""
          new_content = current_content + chunk.content

          # Update message content
          assistant_message.update!(
            content: new_content,
            input_tokens: chunk.input_tokens,
            output_tokens: chunk.output_tokens
          )

          # Broadcast chunk for streaming
          assistant_message.broadcast_append_chunk(chunk.content)
        end
      end

      # Update final message with complete metadata
      assistant_message.update!(
        content: response.content,
        input_tokens: response.input_tokens,
        output_tokens: response.output_tokens,
        model_id: response.model_id
      )
    rescue => e
      error_message = "Error: #{e.message}"
      assistant_message.update!(content: error_message)
      Rails.logger.error("ChatStream Error: #{e.full_message}")
    end
  end
end
