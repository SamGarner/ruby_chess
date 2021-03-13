# frozen_string_literal: false

class Knight
  attr_reader :symbol, :possible_moves, :color
  attr_accessor :current_location

  def initialize(color, location)
    @color = color
    # @symbol = "#{color[0].upcase}k" # uncomment line to use with WSL
    @symbol = (color == :black ? "\u2658" : "\u265E") # comment line to use with WSL
    @current_location = location
    @possible_moves = [1, 2], [2, 1], [1, -2], [2, -1], [-1, -2], [-2, -1],
                      [-1, 2], [-2, 1]
  end
end