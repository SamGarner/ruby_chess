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
        @game.turn = 'white'
        @game.finish_input = 'D4'
        expect(@game.valid_target_space?).to be true
      end
    
      it 'returns true when target occupied by opponent' do
        @game.turn = 'black'
        @game.finish_input = 'H1'
        expect(@game.valid_target_space?).to be true
      end

      it 'returns false when target occupied by ally' do
        @game.turn = 'white'
        @game.finish_input = 'H1'
        expect(@game.valid_target_space?).to be false
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
      before(:each) do
        @game.turn = 'white'
        @game.start_input = 'H1'
      end

      it "returns true when current player's piece" do
        expect(@game.valid_piece_to_move?).to be true
      end

      it "returns false when opposing player's piece" do
        expect(@game.valid_piece_to_move?('black')).to be false
      end

      it 'returns false when empty space' do
        @game.start_input = 'E4'
        expect(@game.valid_piece_to_move?).to be false
      end      
    end

    # describe '#valid_finish_input' do
    #   # covered with #valid_user_input? and valid_target_space? testing
    # end

    describe '#display_to_array_map' do
      before(:each) do
        @board = Board.new
        @game = Game.new(@board)
        # @game.display_to_array_map('A1', 'G3')
        @game.start_display_to_array_map('A1')
        @game.end_display_to_array_map('G3')
      end

      it "sets @start_space = [7, 0] when start_input = 'A1'" do
        expect(@game.start_space).to eq([7, 0])
      end

      it "sets @end_space = [5, 6] when start_input = 'G3'" do
        expect(@game.end_space).to eq([5, 6])
      end
    end

    describe '#commit_move?' do
      context 'when moving piece from [7, 6] to [5, 4]' do
        it 'should have travel_path of [-2, 2]' do
          bishop = Bishop.new('black', [7, 6])
          @board.board_array[7][6] = bishop
          @game.commit_move?(bishop, [5, 4])
          expect(@game.travel_path).to eq([-2, 2])
        end
      end
    end

    describe '#valid_move?' do
      # possible move true and false
      describe '#possible_move?' do
        it 'should be true when desired move in piece.possible_moves' do
          expect(@game.possible_move?(@rook_h1, [0, 5])).to be true
        end

        it 'should be false when desired move in piece.possible_moves' do
          expect(@game.possible_move?(@rook_h1, [2, 2])).to be false
        end
      end

      # WhitePawn
      context 'when a white pawn is attempting en passant capture' do
        before(:each) do
          # @board = Board.new
          # @game = Game.new(@board)
          @black_pawn = BlackPawn.new([3, 6])
          @white_pawn = WhitePawn.new([3, 7])
          @board.board_array[3][6] = @black_pawn
          @board.board_array[3][7] = @white_pawn
        end

        describe '#white_can_en_passant?' do
          it 'should be true if black pawn moved to proper position during last turn' do
            @black_pawn.initial_turn = 8
            @game.total_turn_counter = 9
            expect(@game.white_can_en_passant?(@white_pawn, [2, 6])).to be true
          end

          it 'should be false if it has been more than one turn since black pawn moved' do
            @black_pawn.initial_turn = 6
            @game.total_turn_counter = 9
            expect(@game.white_can_en_passant?(@white_pawn, [2, 6])).to be false
          end
        end

        describe '#valid_white_pawn_move?' do
          it 'should return true when white can white_can_en_passant' do
            @black_pawn.initial_turn = 8
            @game.total_turn_counter = 9
            travel_path = [-1, 1]
            expect(@game.valid_white_pawn_move?(@white_pawn, travel_path, [2, 6])).to be true
          end
        end
      end

      context 'when a white pawn is not attemping en passant capture' do
        before(:each) do
          # @board = Board.new
          # @game = Game.new(@board)
          # @black_pawn = BlackPawn.new([3, 6])
          # @board.board_array[3][6] = @black_pawn
          @white_pawn = WhitePawn.new([6, 6])
          @board.board_array[6][6] = @white_pawn
        end

        describe '#first_move_for_white_pawn' do
          it 'is called by move piece' do
            expect(@white_pawn).to receive(:makes_first_move).once
            @game.move_piece(@white_pawn, [4, 6])
          end

          it 'removes [0, 2] from possible_moves' do
            @game.total_turn_counter = 3
            @game.first_move_for_white_pawn(@white_pawn, [4, 6])
            expect(@white_pawn.possible_moves).to_not include([0, 2])
          end

          it 'sets initial_turn to current turn count if pawn moves two' do
            @game.total_turn_counter = 3
            @game.first_move_for_white_pawn(@white_pawn, [4, 6])
            expect(@white_pawn.initial_turn).to eq(3)
          end

          it ' does not set initial_turn if pawn only moves one' do
            @game.total_turn_counter = 3
            @game.first_move_for_white_pawn(@white_pawn, [5, 6])
            expect(@white_pawn.initial_turn).to eq(0)
          end
        end

        describe '#valid_white_pawn_move?' do
          it 'allows moving two spaces for first move' do
            expect(@game.valid_white_pawn_move?(@white_pawn, [0, 2], [4, 6])).to be true
          end

          it 'does not allow moving two spaces after first move' do
            @white_pawn.makes_first_move([5, 6], 2)
            @white_pawn.current_location = [5, 6]
            @board.board_array[5][6] = @white_pawn
            expect(@game.valid_white_pawn_move?(@white_pawn, [0, 2], [3, 6])).to be false
          end

          xit 'does not allow vertical move if space is blocked' do
            @black_pawn = BlackPawn.new([5, 6])
            @board.board_array[5][6] = @black_pawn
            expect(@game.valid_white_pawn_move?(@white_pawn, [0, 2], [4, 6])).to be false
          end

          xit 'does not allow capture move if no opponent on the space' do
          end

          xit 'does not allow horizontal/illegal move' do
          end
        end
      end
    end

    describe '#piece_exists?' do
      it 'should be true when a piece exists on the space' do
        expect(@game.piece_exists?([7, 7])).to be true
      end

      it 'should be false when a piece exists on the space' do
        expect(@game.piece_exists?([3, 0])).to be false
      end
    end

    describe '#impeding_piece?' do
      it 'should be true when ally is on the destination square' do
        pawn_ally = WhitePawn.new([7, 4])
        @board.board_array[7][4] = pawn_ally
        expect(@game.impeding_piece?(@rook_h1, [-3, 0], [7, 4])).to be true
      end
      
      it 'should be false when opponent is on the destination square' do
        pawn_opponent = BlackPawn.new([7, 5])
        @board.board_array[7][5] = pawn_opponent
        expect(@game.impeding_piece?(@rook_h1, [-2, 0], [7, 5])).to be false
      end

      describe '#horizontal_impediment?' do
        # @rook_h1 white, 7,7
        it 'should be false when there is no piece in the way' do
          expect(@game.horizontal_impediment?(@rook_h1, [-5, 0])).to be false
        end

        context 'when moving towards an ally' do
          before(:each) do
            @pawn_ally = WhitePawn.new([7, 4])
            @board.board_array[7][4] = @pawn_ally
          end

          it 'should be true when ally is in the way - negative check' do
            expect(@game.horizontal_impediment?(@rook_h1, [-5, 0])).to be true
          end

          it 'should be true when ally is in the way - positive check' do
            rook_a1 = Rook.new('white', [7, 0])
            expect(@game.horizontal_impediment?(rook_a1, [5, 0])).to be true
          end
        end
      end
    end

    # describe '#vertical_impediment?' do
    #   # @rook_h1 white, 7,7
    #   context 'when moving towards an ally' do
    #     before(:each) do
    #       @pawn_ally = WhitePawn.new([4, 7])
    #       @board.board_array[4][7] = @pawn_ally
    #     end

    #     it 'should be true when ally is in the way' do
    #       expect(@game.vertical_impediment?(@rook_h1, [-5, 0])).to be true
    #     end

    #     it 'should be true when ally is on the destination square' do
    #       expect(@game.horizontal_impediment?(@rook_h1, [-3, 0])).to be true
    #     end
    #   end

    #   it 'should be false when opponent is on the destination square' do
    #     pawn_opponent = BlackPawn.new([7, 5])
    #     @board.board_array[7][5] = pawn_opponent
    #     expect(@game.horizontal_impediment?(@rook_h1, [-2, 0])).to be false
    #   end

    #   it 'should be false when there is no piece in the way' do
    #     expect(@game.horizontal_impediment?(@rook_h1, [-5, 0])).to be false
    #   end
    # end


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
