# encoding: UTF-8

class ApiController < ActionController::Base
  protect_from_forgery

  def recibecaso
    puts request
    render json: 'ok', status: :ok
  end
end

