ENV['TZ'] = 'UTC'
Encoding.default_internal = 'UTF-8'

unless File.exists? './config.yml'
  puts 'Please provide a config.yml file.'
  exit false
end

require 'yaml'

if ENV['RACK_ENV']
  SiteConfig = YAML.load_file('config.yml')[ENV['RACK_ENV']]
else
  SiteConfig = YAML.load_file('config.yml')['development']
end

Dir.glob(['lib', 'models'].map! {|d| File.join File.expand_path(File.dirname(__FILE__)), d, '*.rb'}).each {|f| require f}

DataMapper.finalize
DataMapper.setup :default, SiteConfig['database_url']

class App < Jsonatra::Base
  configure do
    set :root, File.dirname(__FILE__)
    set :public_folder, File.dirname(__FILE__) + '/public'
  end
end

require './app.rb'
Dir.glob(['controllers'].map! {|d| File.join d, '*.rb'}).each do |f| 
  require_relative f
end
