#!/usr/bin/ruby

require 'mysql'
require 'csv'
require 'spreadsheet'

Spreadsheet.client_encoding = 'UTF-8'

begin
  CSV.foreach("/home/li2mcmug/workspace/chart/morningstar/AAV.csv") do |row|
    puts row
    # use row here...
  end

  con = Mysql.new 'localhost', 'root', 'comp0707', 'stocks'
  puts con.get_server_info
  rs = con.query 'SELECT VERSION()'
  puts rs.fetch_row    
    
rescue Mysql::Error => e
  puts e.errno
  puts e.error
    
ensure
  con.close if con
end
