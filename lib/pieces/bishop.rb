# frozen_string_literal: false

class Bishop
  attr_reader :symbol, :possible_moves, :color
  attr_accessor :current_location

  def initialize(color, location)
    @color = color
    @symbol = "#{color[0].upcase}B"
    @current_location = location
    @possible_moves = [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7],
                      [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7],
                      [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7],
                      [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7]
    # share with Queen ?
  end
end