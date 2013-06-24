#!/usr/bin/ruby

require 'mysql'
require 'csv'
require 'spreadsheet'

Spreadsheet.client_encoding = 'UTF-8'
years = [2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012]

con = Mysql.new 'localhost', 'root', 'comp0707', 'stocks'

begin
  CSV.foreach("/home/li2mcmug/workspace/chart/morningstar/ZNGA.csv") do |row|
    break if row[0] && row[0].match("CAD")

    next if row[0].nil? || !row[0].match("Revenue.*Mil") 
    for i in 1..10
      next if row[i].nil?
      row[i].sub!(',', '')
      amount = row[i].to_i * 1000000
      puts amount
      rs = con.query "insert into symbols(symbol, year, revenue) values(\'ZNGA\',#{years[i-1]},#{amount})"
    end
  end
    
rescue Mysql::Error => e
  puts e.errno
  puts e.error
    
ensure
  con.close if con
end
