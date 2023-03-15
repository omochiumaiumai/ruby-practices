# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(mark)
    @mark = mark
  end

  def split_marks
    @mark.split(',')
  end

  def score_parse
    shots = []
    scores = []
    slice_scores = []

    split_marks.each do |mark|
      shots << Shot.new(mark)
    end

    shots.each do |shot|
      scores << shot.score
      frame_size = scores.size / 2
      scores << 0 if frame_size < 9 && shot.mark == 'X'
    end

    scores.each_slice(2) { |score| slice_scores << score }

    if slice_scores.size > 10
      slice_scores[9].concat(slice_scores.last)
      slice_scores.delete(slice_scores.last)
    end
    slice_scores
  end

  def frames
    score_parse.map do |shot|
      Frame.new(shot[0], shot[1], shot[2])
    end
  end

  def calc_score
    @frames = frames
    scores = []
    @frames.each do |frame|
      scores << frame.score + bonus_score(frame)
    end
    scores.sum
  end

  def output
    puts calc_score
  end

  def bonus_score(frame)
    current_frame_index = @frames.index(frame)

    return 0 unless frame.strike? || frame.spare?
    return 0 unless current_frame_index < 9

    if frame.strike?
      next_frame_strike_bonus(current_frame_index)
    elsif frame.spare?
      @frames[current_frame_index + 1].first_shot.score
    end
  end

  def next_frame_strike_bonus(current_frame_index)
    if @frames[current_frame_index + 1].strike? && current_frame_index < 8
      @frames[current_frame_index + 1].first_shot.score + @frames[current_frame_index + 1 + 1].first_shot.score
    else
      @frames[current_frame_index + 1].first_shot.score + @frames[current_frame_index + 1].second_shot.score
    end
  end
end
