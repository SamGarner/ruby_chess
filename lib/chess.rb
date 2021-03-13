# frozen_string_literal: false

require 'pry'
require_relative 'pieces/king.rb'
require_relative 'pieces/queen.rb'
require_relative 'pieces/bishop.rb'
require_relative 'pieces/knight.rb'
require_relative 'pieces/rook.rb'
require_relative 'pieces/white_pawn.rb'
require_relative 'pieces/black_pawn.rb'
require_relative 'board.rb'
require_relative 'in_check_conditions.rb'
require_relative 'move_impediment_conditions.rb'
require_relative 'game.rb'

board = Board.new
game = Game.new(board)
# game.initialize_pieces
board.place_starting_pieces
game.gameboard.display_board
game.define_castling_mappings
while game.game_over == false
  game.take_turn
  game.gameboard.display_board
end
# binding.pry
