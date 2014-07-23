$:.unshift File.expand_path("./../lib", __FILE__)

require 'bundler'
Bundler.require

require 'app'
# require 'sinatra/reloader'

run IdeaBoxApp
