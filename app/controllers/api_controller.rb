# encoding: UTF-8

class ApiController < ActionController::Base
  protect_from_forgery with: :exception

  def recibecaso
    puts request
    render json: 'ok', status: :ok
  end
end

