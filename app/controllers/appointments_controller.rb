class AppointmentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def extract
    text = params[:text]

    begin
      result = AppointmentExtractorService.new.extract(text)
      render json: result
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end
