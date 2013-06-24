#!/usr/bin/ruby

require 'mysql'
require 'csv'
require 'spreadsheet'

Spreadsheet.client_encoding = 'UTF-8'
years = [2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012]

con = Mysql.new 'localhost', 'root', 'comp0707', 'stocks'

begin
  Dir.foreach("/home/li2mcmug/workspace/chart/morningstar") do |file|
    puts file
    next if !file.match("csv") || File.directory?("/home/li2mcmug/workspace/chart/morningstar/#{file}")
    CSV.foreach("/home/li2mcmug/workspace/chart/morningstar/#{file}", {col_sep: ",", quote_char: "\x00"}) do |row|
      symbol = file.split(".")[0]        

      break if row[0] && row[0].match("CAD")

      next if row[0].nil? || !row[0].match("Revenue.*Mil") 
      for i in 1..10
        next if row[i].nil?
        row[i].sub!(',', '')
        amount = row[i].to_i * 1000000
        rs = con.query "insert into symbols(symbol, year, revenue) values(\'#{symbol}\',#{years[i-1]},#{amount})"
      end
    end
  end
rescue Mysql::Error => e
  puts e.errno
  puts e.error
    
ensure
  con.close if con
end
