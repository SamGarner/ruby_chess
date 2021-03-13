# frozen_string_literal: false

class BlackPawn
  attr_reader :symbol, :color, :starting_location, :capture_moves
  attr_accessor :current_location, :possible_moves, :initial_turn

  def initialize(location)
    @color = :black
    # @symbol = 'Bp' # uncomment line to use with WSL # "#{color[0].upcase}p" 
    @symbol = "\u2659" # comment line to use with WSL
    @current_location = location
    @starting_location = location
    @possible_moves = [0, -1], [0, -2]
    @capture_moves = [-1, -1], [1, -1]
    @initial_turn = 0
  end

  def makes_first_move(ending_space, move_number)    
    self.possible_moves = [[0, -1]]
    self.initial_turn = move_number if starting_location[0] - ending_space[0] == -2
  end

  # def passant_vulnerable?(starting_space, ending_space)
  #   (starting_space[1] - ending_space[1]).abs == 2
  # end
end
