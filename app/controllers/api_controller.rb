# encoding: UTF-8

class ApiController < ActionController::Base

  def recibecaso
    puts request
    render json: 'ok', status: :ok
  end
end

