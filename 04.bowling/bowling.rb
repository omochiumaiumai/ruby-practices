# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

def strike_score_plus(frames, count)
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
  point +=
    if frame[0] == 10 && count < 10
      strike_score_plus(frames, count)
    elsif frame.sum == 10 && count < 10
      (frame.sum + frames[count][0])
    else
      frame.sum
    end
end
puts point
