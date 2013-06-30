#!/usr/bin/ruby

require 'mysql'
require 'csv'
require 'spreadsheet'

Spreadsheet.client_encoding = 'UTF-8'

con = Mysql.new 'localhost', 'root', 'comp0707', 'stocks'

begin
  Dir.foreach("/home/li2mcmug/workspace/chart/morningstar") do |file|
    puts file
    years = nil

    next if !file.match("csv") || File.directory?("/home/li2mcmug/workspace/chart/morningstar/#{file}")

    CSV.foreach("/home/li2mcmug/workspace/chart/morningstar/#{file}", { quote_char: "\x00"}) do |row|
      symbol = file.split(".")[0]
      row = row.join(',').gsub(/(?m),(?=[^"]*"(?:[^"\r\n]*"[^"]*")*[^"\r\n]*$)/,'')
              .gsub(' ','').split(',')

      if row.any?{|field| /201\d-/.match(field)}
        years = row.map{|field| field ? field.gsub(/-\d\d/,'') : ''}
      end

      break if (row[0] && row[0].match("CAD")) || file.split(".").size() > 2

      next if row[0].nil? || !row[0].match("EarningsPerShare") 

      for i in 1..10
        next if row[i].nil?
        row[i].sub!(',', '')
        row[i].sub!('"', '')
        amount = row[i].to_f

        query = "insert into symbols(symbol, year, eps) values(\'#{symbol}\',#{years[i]},#{amount}) on duplicate key update eps = #{amount}"
puts query
        rs = con.query query
      end
    end
  end
rescue Mysql::Error => e
  puts e.errno
  puts e.error
    
ensure
  con.close if con
end
