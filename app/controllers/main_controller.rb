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
  # GET /
  def index
    # Store invite token
    session[:invite_token] = params[:invite_token] if params[:invite_token] && invite_registration
  end
  # POST /
  def add_cookie
    cookies[:return_to] = params[:return_url]
    cookies[:greenlight_name] = params[:cookie]
    # cookies.encrypted[:greenlight_name]
  end  
  # GET /
  def sign_in_api
    uri = URI('https://bigbluebutton.miroma.in/b/u/login')
    res = Net::HTTP.post_form(uri, 'utf8' => '&#x2713;','session[email]' => params[:email],'session[password]' => params[:password],'authenticity_token' => params[:token], 'max' => '50')
    puts res.body
  end

  # GET /
  def checkkk
    p "SUCCESS"
  end

  # GET /
  def checkkU
    @api = "SUCCESS"
    render("api/api")
  end

  # GET /
  def sign_in_page
    uri = URI('https://bigbluebutton.miroma.in/b/signin')
    res = Net::HTTP.get(uri)
    # p res.body
    @api = Nokogiri::HTML.parse(res.body)
    render("api/api")
    #  @api = "SUCCESS"
    # render("api/api")
  end
end
