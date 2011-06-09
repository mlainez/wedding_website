#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'bundler'
Bundler.require

require 'sinatra'
require 'sinatra/r18n'
require 'haml'
require 'cgi'

set :haml, :format => :html5
set :default_locale, 'fr'

before '/:locale/*' do |locale_code, remaining_path|
  if r18n.available_locales.map(&:code).include?(locale_code)
    r18n.locale = locale_code
    @locale = locale_code
  else
    redirect "/#{determine_default_locale.code}/#{remaining_path}"
  end
end

get '/' do
  redirect "/#{determine_default_locale.code}/index"
end

get '/:locale/:page' do |locale, page|
  @page = page
  @host = request.env['SERVER_PORT'] == '80' ? request.host : CGI.escape(request.host_with_port)
  haml :"#{page}.#{params[:locale]}"
end

def determine_default_locale
  (r18n.locales & r18n.available_locales).last || r18n.default
end
