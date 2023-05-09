# frozen_string_literal: true

class Option
  attr_reader :all, :reverse, :long

  def initialize(options)
    @all = options['a'] || false
    @reverse = options['r'] || false
    @long = options['l'] || false
  end
end
