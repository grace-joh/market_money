class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  private

  def render_not_found_response(error)
    render json: ErrorSerializer.not_found(error), status: 404
  end
end
