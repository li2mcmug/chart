#!/usr/bin/ruby

require 'mysql'
require 'csv'
require 'spreadsheet'

Spreadsheet.client_encoding = 'UTF-8'

con = Mysql.new 'localhost', 'root', 'comp0707', 'stocks'

begin
  Dir.foreach("/home/li2mcmug/workspace/chart/morningstar/price") do |file|
    symbol = file.split(".")[0]
    file_path = "/home/li2mcmug/workspace/chart/morningstar/price/#{file}"

    next if !file.match("csv") || File.directory?(file_path) || File.new(file_path, "r").size == 0

    File.open(file_path) do |f|
      price = f.readline.split(",")[6]
      update_stmt = "update symbols set price = #{price} where symbol = \'#{symbol}\'"
      puts update_stmt
      rs = con.query update_stmt
    end      
  end
rescue Mysql::Error => e
  puts e.errno
  puts e.error
    
ensure
  con.close if con
end
