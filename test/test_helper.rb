ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
Bundler.require

require File.expand_path('../../env.rb', __FILE__)
