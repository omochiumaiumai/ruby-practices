require "Date" 
require "optparse"

options = ARGV.getopts("m:","y:")
option_month = options["m"]
option_year = options["y"]

today = Date.today
tomonth = today.month
toyear = today.year
weeks = Date.today.wday

def calender(i,o,days,beginning)
  months_years =  "#{i}月 #{o}"
  count = 0
  if o.to_i >= 10000
    puts "year #{o.to_i} not in range 1..9999"
  else
    puts months_years.center(20)
    puts "日 月 火 水 木 金 土"
    beginning.times do|space|
      print "   "
      count += 1
    end
    (1..days.to_i+ 1).each do |day|
      count += 1
      if day < 10 && count % 7 == 0
        puts day.to_s.center(3)
      elsif day < 10
        print day.to_s.center(3)
      elsif day >= 10 && count % 7 == 0
        puts day.to_s.center(3)
      else
        print day.to_s.center(3)
      end
    end
    puts " "
    puts " "
  end
end


if option_month.to_i >= 13 || option_month == "0"
  puts "#{option_month.to_i} is neither a month number (1..12) nor a name"
else
  if option_month || option_year 
    option_month ||= tomonth
    option_year ||= toyear
    firstday = Date.new(option_year.to_i,option_month.to_i,1)
    lastday = Date.new(option_year.to_i,option_month.to_i,-1)
  else
    option_month ||= tomonth
    option_year ||= toyear
    firstday = Date.new(toyear,tomonth,1)
    lastday = Date.new(toyear,tomonth,-1)
  end

  days = lastday - firstday
  beginning = firstday.wday.to_i

  if option_month && option_year
    calender(option_month,option_year,days,beginning)
  elsif option_month 
    calender(option_month,toyear,days,beginning)
  elsif opyear
    calender(tomonth,option_year,days,beginning)
  else
    calender(tomonth,toyear,days,beginning)
  end