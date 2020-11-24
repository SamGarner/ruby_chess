# frozen_string_literal: false

require 'pry'
require_relative '../chess.rb'

describe Game do
    # create game and game board to be shared across tests below
    before(:each) do
      @board = Board.new
      @game = Game.new(@board)
      @rook_h1 = Rook.new('white', [7, 7])
      # @pawn_g1 = BlackPawn.new([7, 6])
      # @pawn_h7 = WhitePawn.new([1, 7])
      @board.board_array[7][7] = @rook_h1
      # @board.board_array[7][6] = @pawn_g1
    end

    describe '#valid_target_space?' do
      it 'returns true when target space is empty' do
        expect(@game.valid_target_space?([4, 3], 'black')).to be true
      end
    
      it 'returns true when target occupied by opponent' do
        expect(@game.valid_target_space?([7, 7], 'black')).to be true
      end

      it 'returns false when target occupied by ally' do
        expect(@game.valid_target_space?([7, 7], 'white')).to be false
      end
    end

    # describe '#valid_start_input?' do  #redundant testing, see notes within
      # xit 'returns false when player does not have a piece at that space' do
      #   #redundant - #valid_target_space
      # end

      # it 'returns false when not a space between A1 and H8' do
      #   expect(@game.valid_start_input?('J8')).to be false
      #   # redundant with #valid_user_input? testing
      # end

      # xit "returns true when space with player's piece on it" do
      #   # redundant - #valid_piece_to_move
      # end
    # end

    describe '#valid_user_input?' do
      it 'should be false when space not on gameboard' do
        expect(@game.valid_user_input?('J8')).to be false
      end

      it 'should be true when space is on gameboard' do
        expect(@game.valid_user_input?('A3')).to be true
      end
    end

    describe '#valid_piece_to_move?' do
      it "returns true when current player's piece" do
        expect(@game.valid_piece_to_move?([7, 7], 'white')).to be true
      end

      it "returns false when opposing player's piece" do
        expect(@game.valid_piece_to_move?([7, 7], 'black')).to be false
      end

      it 'returns false when empty space' do
        expect(@game.valid_piece_to_move?([4, 4], 'black')).to be false
      end      
    end

    # describe '#valid_finish_input' do
    #   # covered with #valid_user_input? and valid_target_space? testing
    # end

    describe '#display_to_array_map' do
      before(:each) do
        @board = Board.new
        @game = Game.new(@board)
        @game.display_to_array_map('A1', 'G3')
      end

      it "sets @start = [7, 0] when start_input = 'A1'" do
        expect(@game.start).to eq([7, 0])
      end

      it "sets @finish = [5, 6] when start_input = 'G3'" do
        expect(@game.finish).to eq([5, 6])
      end
    end

    context 'when attempting horizontal moves' do
      # it 'horizontal_impediment? will be true if a piece is in the way' do
      #   ba = @board.board_array
      #   expect(@game.horizontal_impediment?(@rook_h1, [-2, 0], ba)).to be true
      # end

      xit 'will not happen if a piece is in the way' do
        pawn_g1 = WhitePawn.new([7, 6])
        @board.board_array[7][6] = pawn_g1
        @game.move_piece(@rook_h1, [7, 5])
        expect(@board.board_array[7][7]).to eq(@rook_h1)
        # expect(@game.move_piece(@rook_h1, [7, 5])).to be nil
        # expect(@game.move_piece(@rook_h1, [7, 5])).to_not change(@board, :board_array)
        # not to change
      end

      it 'will move if there are no pieces in the way' do
        @game.move_piece(@rook_h1, [7, 5])
        expect(@board.board_array[7][5]).to eq(@rook_h1)
      end

      it 'will leave a vacant space where it moved from' do
        @game.move_piece(@rook_h1, [7, 5])
        expect(@board.board_array[7][7]).to eq('__')
      end

      it 'will take the opponents piece if one is on the target square' do
        pawn_h7 = BlackPawn.new([1, 7])
        @board.board_array[1][7] = pawn_h7
        @game.move_piece(@rook_h1, [1, 7])
        expect(pawn_h7.current_location).to be nil
      end

      xit 'will not happen if ally is on the target square' do
        pawn_g1 = WhitePawn.new([7, 6])
        @board.board_array[7][6] = pawn_g1
        @game.move_piece(@rook_h1, [7, 6])
        expect(@board.board_array[7][6]).to eq(pawn_g1)
      end      

      xit 'will not happen if the piece cannot move horizontally' do
        bishop_f1 = Bishop.new('black', [7, 5])
        @board.board_array[7][5] = bishop_f1
        @game.move_piece(bishop_f1, [7, 7])
        expect(@board.board_array[7][5]).to eq(bishop_f1)
      end

      # MAKE A SPEC FILE FOR EACH PIECE TO TEST MOVEMENT ? CHECK METZ

      # it 'impeding_piece? will be true if a piece is in the way' do
      #   expect(@game.impeding_piece?(@rook_h1, [-2, 0])).to be true
      # end

      # it 'valid_move? will be false if a piece is in the way' do
      #   expect(@game.valid_move?(@rook_h1, [-2, 0])).to be false
      # end
    end
end
  # 1 - diag/bishop will not move if piece impeding the path

  # 2 - check old/new space after bishop move diagonally
  # 3 - bishop cannot move vertically
  # 4 - bishop cannt move horizontally
