# frozen_string_literal: true

# BigBlueButton open source conferencing system - http://www.bigbluebutton.org/.
#
# Copyright (c) 2018 BigBlueButton Inc. and by respective authors (see below).
#
# This program is free software; you can redistribute it and/or modify it under the
# terms of the GNU Lesser General Public License as published by the Free Software
# Foundation; either version 3.0 of the License, or (at your option) any later
# version.
#
# BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License along
# with BigBlueButton; if not, see <http://www.gnu.org/licenses/>.
require 'net/http'
require 'uri'
require 'nokogiri'
class MainController < ApplicationController
  include Registrar
  include Authenticator
  # GET /
  def index
    # Store invite token
    session[:invite_token] = params[:invite_token] if params[:invite_token] && invite_registration
  end
   
  # GET /
  def sign_in_api
    @api = params
    @api[:status] = 0
    @api[:isForStartCall] = false
    user = User.include_deleted.find_by(email: params[:email].downcase)
    if user && user.try(:authenticate,
      params[:password])
      session[:user_id] = user.id
      @api[:status] = 1
    end 
    render("api/api")
  end

  def start_call
    @user = User.include_deleted.find_by(email: params[:email].downcase)
    @api = {"status"=>1,"isForStartCall"=>true,"room"=>params['roomId']}
    render("api/api")
  end  
  def join_call
    @api = {"status"=>1,"isForJoinCall"=>true,"room"=>params['roomId'],"name"=>params['username']}
    render("api/api")
  end  

  # POST /
  def create_room 
     @api = {"status"=>0,"isForCreateRoom"=>true,"msg"=>"Room creation failed"}
    if current_user
      # if room_limit_exceeded
      #   @api[:msg] = "Room limit exceeded"
      # else
      @api[:msg] = "Room CREATION"
      @room = Room.new(name: params[:name], access_code: params[:access_code])
      @room.owner = current_user
      @room.room_settings = create_room_settings_string(room_params)  
      if @room.save
        @api = {"status"=>1,"isForCreateRoom"=>true,"msg"=>"Successfully created new room","data"=>@room}
      end  
      # end
    else
      @api[:msg] = "You are not logged in"
    end  
    render("api/api")
  end  
end
