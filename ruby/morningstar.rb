require "rubygems"

# The part that activates bundler in your app:
require "bundler/setup" 
require 'mysql'

client = Mysql::Client.new(:host => "localhost", :username => "root", :password => "comp0707")


