score = ARGV[0] #引数取得
scores = score.split(",")
shots = []
scores.each do |s|
  if s == "X" #strike
    shots << 10
    shots << 0
  else
    shots << s.to_i #足し算するために数字に変換
  end
end

frames = []
shots.each_slice(2) do |s| #フレーム毎に分割
  frames << s
end

def strike_score_plus(frames,count)
  if frames[count][0] == 10
      10 + 10 + frames[count + 1][0]
    else
      10 + frames[count].sum
    end
end

point = 0
count = 0
frames.each do |frame|
  count += 1
  print frame
  print "#{count}回目"
  if frame[0] == 10 && count < 10 # strike
    point += strike_score_plus(frames,count)
  elsif frame.sum == 10 && count < 10 # spare
    point += (frame.sum + frames[count][0])
  else
    point += frame.sum
  end
  puts point
end
puts point