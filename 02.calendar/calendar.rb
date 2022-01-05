require "Date" 
require "optparse"

options = ARGV.getopts("m:","y:")
option_month = options["m"]
option_year = options["y"]
today = Date.today
month = options["m"] || today.month
year = options["y"] || today.year
weeks = Date.today.wday

def calender(month,year,days,beginning)
  months_years = "#{month}月 #{year}"
  count = 0
  puts months_years.center(20)
  puts "日 月 火 水 木 金 土"
  beginning.times do|space|
    print "   "
    count += 1
  end
  (1..days.to_i + 1).each do |day|
    count += 1
    if count % 7 == 0
      puts day.to_s.rjust(2)
    else
      print day.to_s.rjust(2) + " "
    end
  end
  puts " "
  puts " "
end
if option_month.to_i >= 13 || option_month == "0"
  raise "#{option_month.to_i} is neither a month number (1..12) nor a name"
end
option_month ||= month
option_year ||= year
firstday = Date.new(year.to_i,month.to_i,1)
lastday = Date.new(year.to_i,month.to_i,-1)
days = lastday - firstday
beginning = firstday.wday.to_i

calender(month,year,days,beginning)
