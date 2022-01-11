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



point = 0
count = 0
frames.each do |frame|
  count += 1
  if frame[0] == 10 && count < 10 # strike
    p frames[count]
    point += (10 + frames[count].sum) #次のフレームの一投目と二投目を加算するには
  elsif frame.sum == 10 && count < 10 # spare
    point += (frame.sum + frames[count][0])
  else
    point += frame.sum
  end
end
puts point

