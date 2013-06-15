class OmniauthorizeController < ApplicationController
  respond_to :json

  def create
    puts "^"*128
    puts env["omniauth.auth"]["uid"]
    puts env["omniauth.auth"]["info"]["nickname"]
    puts env["omniauth.auth"]["info"]["image"]
    puts env["omniauth.auth"]["credentials"]["token"]
    puts env["omniauth.auth"]["credentials"]["secret"]
  end
end