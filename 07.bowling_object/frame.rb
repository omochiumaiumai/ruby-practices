# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot

  def initialize(first_shot, second_shot, third_shot = nil)
    @first_shot = first_shot
    @second_shot = second_shot
    @third_shot = third_shot
  end

  def score
    score = @first_shot.score + @second_shot.score
    score += @third_shot.score if @third_shot
    score
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    @first_shot.score + @second_shot.score == 10 unless strike?
  end
end
