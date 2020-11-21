# frozen_string_literal: false

require 'pry'
require_relative '../chess.rb'

describe Game do
    # create game and game board to be shared across tests below
  describe '#valid_move?' do
    # let(:board) { Board.new }
    # subject(:game) { described_class.new(board) }
    # let(:rook_h1) { Rook.new('black', [7, 7]) }
    # let(:pawn_g7) { Pawn.new('black', [7, 6]) }
    # let(:pawn_h7) { Pawn.new('white', [1, 7]) }

    board = Board.new
    game = Game.new(board)
    rook_h1 = Rook.new('black', [7, 7])
    pawn_g1 = Pawn.new('black', [7, 6])
    pawn_h7 = Pawn.new('white', [1, 7])

    context 'when attempting horizontal moves' do
      it 'horizontal_impediment?' do
        board.board_array[7][7] = rook_h1
        board.board_array[7][6] = pawn_g1
        ba = board.board_array
        # attempt = 
        # game.move_piece(rook_h1, [7, 6])
        expect(game.horizontal_impediment?(rook_h1, [-2, 0], ba)).to be true
        # expect(game.move_piece(rook_h1, [7, 5])).to be nil
        # binding.pry
      end

      it 'cannot move through another piece' do
        board = Board.new
        game = Game.new(board)
        rook_h1 = Rook.new('black', [7, 7])
        pawn_g1 = Pawn.new('black', [7, 6])
        pawn_h7 = Pawn.new('white', [1, 7])

        board.board_array[7][7] = rook_h1
        board.board_array[7][6] = pawn_g1
        # ba = board.board_array
        # attempt = 
        # game.move_piece(rook_h1, [7, 6])
        # expect(game.horizontal_impediment?(rook_h1, [-2, 0], ba)).to be true
        game.move_piece(rook_h1, [7, 5])
        expect(game.move_piece(rook_h1, [7, 5])).to be nil
        # binding.pry
      end

      # working (with this example):
        # horizontal impediment?
        # impeding_piece?
        # valid_move?

      it 'impeding_piece?' do
        board = Board.new
        game = Game.new(board)
        rook_h1 = Rook.new('black', [7, 7])
        pawn_g1 = Pawn.new('black', [7, 6])
        pawn_h7 = Pawn.new('white', [1, 7])
        
        board.board_array[7][7] = rook_h1
        board.board_array[7][6] = pawn_g1
        expect(game.impeding_piece?(rook_h1, [-2, 0])).to be true
      end

      it 'valid_move?' do
        board = Board.new
        game = Game.new(board)
        rook_h1 = Rook.new('black', [7, 7])
        pawn_g1 = Pawn.new('black', [7, 6])
        pawn_h7 = Pawn.new('white', [1, 7])

        board.board_array[7][7] = rook_h1
        board.board_array[7][6] = pawn_g1
        expect(game.valid_move?(rook_h1, [-2, 0])).to be false
      end
    end
  end
  # 1 - diag/bishop will not move if piece impeding the path

  # 2 - check old/new space after bishop move diagonally
  # 3 - bishop cannot move vertically
  # 4 - bishop cannt move horizontally

end