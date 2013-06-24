#!/usr/bin/ruby

require 'mysql'
require 'csv'
require 'spreadsheet'

Spreadsheet.client_encoding = 'UTF-8'

begin
  CSV.foreach("/home/li2mcmug/workspace/chart/morningstar/A.csv") do |row|
    next if row[0].nil? || !row[0].match("Revenue.*Mil")
    for i in 1..11
      puts row[i].sub(',', '')
    end
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
