class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_response

  private

  def render_not_found_response(error)
    render json: ErrorSerializer.serialize(error), status: 404
  end

  def render_invalid_response(error)
    render json: ErrorSerializer.serialize(error), status: 400
  end
end
