# frozen_string_literal: false

require 'pry'
require_relative '../lib/game.rb'
require_relative '../lib/pieces/king'
require_relative '../lib/pieces/queen'
require_relative '../lib/pieces/bishop'
require_relative '../lib/pieces/knight'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/white_pawn'
require_relative '../lib/pieces/black_pawn'

describe Board do
  context 'when checking a space' do
    subject(:space_check_board) { described_class.new }
    let(:existing_rook) { instance_double(Rook, color: :black) }

    before do
      space_check_board.board_array[0][7] = existing_rook
    end
  
    describe '#piece_exists?' do
      it 'should be true when a piece exists' do
        result = space_check_board.piece_exists?([0, 7])
        expect(result).to be true
      end

      it 'should be false when the space is empty' do
        result = space_check_board.piece_exists?([2, 2])
        expect(result).to be false
      end
    end

    describe '#attacking_opponent?' do
      let(:ally) { instance_double(Bishop, color: :black) }
      let(:enemy) { instance_double(Bishop, color: :white) }

      before do
        space_check_board.board_array[0][5] = ally
        space_check_board.board_array[4][7] = enemy
      end

      it 'should be false when checking the space of an ally' do
        result = space_check_board.attacking_opponent?(existing_rook, [0, 5])
        expect(result).to be false
      end

      it 'should be true when checking the space of an enemy' do
        result = space_check_board.attacking_opponent?(existing_rook, [4, 7])
        expect(result).to be true
      end
    end
  end

  describe '#update_board' do
    subject(:board_to_update) { described_class.new }
    let(:rook_for_update) { instance_double(Rook, current_location: [0, 7]) }
    let(:desired_space) { [4, 7] }

    context 'when moving rook from [0, 7] to [4, 7]' do
      it 'should update board_array[4][7] to contain the rook' do
        board_to_update.update_board(rook_for_update, desired_space)
        new_space = board_to_update.board_array[desired_space[0]][desired_space[1]]
        expect(new_space).to eq(rook_for_update)
      end

      it 'should update board_array[0][7] to be a blank space' do
        board_to_update.update_board(rook_for_update, desired_space)
        location = rook_for_update.current_location
        old_space = board_to_update.board_array[location[0]][location[1]]
        expect(old_space).to eq('_') # comment line to use with WSL
        # expect(old_space).to eq('__') # uncomment line to use with WSL
      end
    end
  end

  describe '#destroy_enemy' do
    subject(:board_for_attack) { described_class.new }
    let(:rook) { instance_double(Rook, color: :white) }
    let(:enemy_pawn) { instance_double(BlackPawn, current_location: [1, 1]) }

    before do
      board_for_attack.board_array[1][1] = enemy_pawn
      allow(enemy_pawn).to receive(:current_location=)
      allow(enemy_pawn).to receive(:current_location)
    end

    context 'when white rook attacks black pawn at [1][1]' do
      it 'should set the current location of the attacked pawn to nil' do
        board_for_attack.destroy_enemy([1, 1])
        result = enemy_pawn.current_location
        expect(result).to be nil
      end

      # it "should set board_array[1][1] to be '__'" do # uncomment line to use with WSL
      it "should set board_array[1][1] to be '_'" do # comment line to use with WSL
        board_for_attack.destroy_enemy([1, 1])
        result = board_for_attack.board_array[1][1]
        expect(result).to eq('_') # comment line to use with WSL
        # expect(result).to eq('__') # uncomment line to use with WSL
      end
    end
  end
end

describe Game do
  describe '#choose_move' do  
    subject(:choose_move_game) { described_class.new(choose_move_board) }
    let(:choose_move_board) { instance_double(Board) }

    before do
      allow(choose_move_game).to receive(:choose_move_when_in_check)
      allow(choose_move_game).to receive(:choose_piece_to_move)
      allow(choose_move_game).to receive(:which_piece_selected)
      allow(choose_move_game).to receive(:choose_where_to_move)
    end

    it 'should call #choose_move_when_in_check' do
      expect(choose_move_game).to receive(:choose_move_when_in_check)
      choose_move_game.choose_move
    end

    it 'should call #choose_piece_to_move' do
      expect(choose_move_game).to receive(:choose_piece_to_move)
      choose_move_game.choose_move
    end

    it 'should call #which_piece_selected' do
      expect(choose_move_game).to receive(:which_piece_selected)
      choose_move_game.choose_move
    end

    it 'should call #choose_where_to_move' do
      expect(choose_move_game).to receive(:choose_where_to_move)
      choose_move_game.choose_move
    end
  end

  describe '#choose_move_when_in_check' do
    subject(:choose_move_when_check_game) { described_class.new(choose_move_when_check_board) }
    let(:choose_move_when_check_board) { instance_double(Board) }
    let(:friendly_king_double) { instance_double(King) }

    before do
      allow(choose_move_when_check_game).to receive(:fetch_friendly_king)
      choose_move_when_check_game.instance_variable_set(:@friendly_king, friendly_king_double)
      allow(friendly_king_double).to receive(:in_check)
    end

    it 'should call #fetch_friendly_king' do
      expect(choose_move_when_check_game).to receive(:fetch_friendly_king)
      choose_move_when_check_game.choose_move_when_in_check
    end

    it 'should call friendly_king.in_check' do
      expect(friendly_king_double).to receive(:in_check)
      choose_move_when_check_game.choose_move_when_in_check
    end

    it 'should call #checkmate? if friendly_king.in_check is true' do
      allow(friendly_king_double).to receive(:in_check).and_return(true)
      expect(choose_move_when_check_game).to receive(:checkmate?)
      choose_move_when_check_game.choose_move_when_in_check
    end

    it 'should not call #checkmate? if friendly_king.in_check is false' do
      allow(friendly_king_double).to receive(:in_check).and_return(false)
      expect(choose_move_when_check_game).to_not receive(:checkmate?)
      choose_move_when_check_game.choose_move_when_in_check
    end

    it "should call #end_game if local variable 'resign' is true" do
      allow(friendly_king_double).to receive(:in_check).and_return(true)
      allow(choose_move_when_check_game).to receive(:checkmate?).and_return(true)
      expect(choose_move_when_check_game).to receive(:end_game)
      choose_move_when_check_game.choose_move_when_in_check
    end

    it "should not call #end_game if local variable 'resign' is false" do
      allow(friendly_king_double).to receive(:in_check).and_return(true)
      allow(choose_move_when_check_game).to receive(:checkmate?).and_return(false)
      expect(choose_move_when_check_game).to_not receive(:end_game)
      choose_move_when_check_game.choose_move_when_in_check
    end
  end

    # create game and game board to be shared across tests below
    before(:each) do
      @board = Board.new
      @game = Game.new(@board)
      @rook_h1 = Rook.new(:white, [7, 7])
      # @pawn_g1 = BlackPawn.new([7, 6])
      # @pawn_h7 = WhitePawn.new([1, 7])
      @board.board_array[7][7] = @rook_h1
      # @board.board_array[7][6] = @pawn_g1
    end

    describe '#valid_target_space?' do
      it 'returns true when target space is empty' do
        @game.turn = :white
        @game.finish_input = 'D4'
        expect(@game.valid_target_space?).to be true
      end
    
      it 'returns true when target occupied by opponent' do
        @game.turn = :black
        @game.finish_input = 'H1'
        expect(@game.valid_target_space?).to be true
      end

      it 'returns false when target occupied by ally' do
        @game.turn = :white
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
        @game.turn = :white
        @game.start_input = 'H1'
      end

      it "returns true when current player's piece" do
        expect(@game.valid_piece_to_move?).to be true
      end

      it "returns false when opposing player's piece" do
        expect(@game.valid_piece_to_move?(:black)).to be false
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
      subject(:game_commit_move) { described_class.new(board_commit) }
      let(:board_commit) { instance_double(Board) }
      let(:piece) { instance_double(Bishop) }
      let(:desired_space) { [3, 4] }

      before do
        game_commit_move.instance_variable_set(:@travel_path, [1, 1])
        allow(game_commit_move).to receive(:get_travel_path).with(piece, desired_space)
        travel_path = game_commit_move.instance_variable_get(:@travel_path)
        allow(game_commit_move).to receive(:valid_move?).with(piece, desired_space)
      end

      it 'should call #get_travel_path' do
        expect(game_commit_move).to receive(:get_travel_path).once
        game_commit_move.commit_move?(piece, desired_space)
      end

      it 'should call #valid_move?' do
        expect(game_commit_move).to receive(:valid_move?).once
        game_commit_move.commit_move?(piece, desired_space)
      end
    end

    describe '#get_travel_path' do
      context 'when moving piece from [7, 6] to [5, 4]' do
        let(:bishop) { instance_double(Bishop, color: :black, current_location: [7, 6]) }
        it 'should have travel_path of [-2, 2]' do
          # bishop = Bishop.new('black', [7, 6])
          @board.board_array[7][6] = bishop
          @game.get_travel_path(bishop, [5, 4])
          expect(@game.travel_path).to eq([-2, 2])
        end
      end
    end

    describe 'when using #valid_move?' do
      subject(:valid_move_game) { described_class.new(valid_move_board) }
      let(:valid_move_board) { instance_double(Board) }
      let(:rook) { instance_double(Rook) }

      describe '#possible_move?' do
        before do
          allow(rook).to receive(:possible_moves).and_return([[0, 1], [0, 2], [0, 3], [0, 4],
                                                              [0, 5], [0, 6], [0, 7], [1, 0],
                                                              [2, 0], [3, 0], [4, 0], [5, 0],
                                                              [6, 0], [7, 0], [0, -1], [0, -2],
                                                              [0, -3], [0, -4], [0, -5], [0, -6],
                                                              [0, -7], [-1, 0], [-2, 0], [-3, 0],
                                                              [-4, 0], [-5, 0], [-6, 0], [-7, 0]])
        end

        it 'should be true when desired move in piece.possible_moves' do
          valid_move_game.instance_variable_set(:@travel_path, [0, 5])
          expect(valid_move_game.possible_move?(rook)).to be true
        end

        it 'should be false when desired move not in piece.possible_moves' do
          valid_move_game.instance_variable_set(:@travel_path, [2, 2])
          expect(valid_move_game.possible_move?(rook)).to be false
        end
      end

      context 'moving a Knight' do
        let(:knight) { Knight.new(:black, [2, 2]) }

        before do
          # allow(piece).to receive(:class).and_return(Knight)
          allow(valid_move_game).to receive(:possible_move?)
        end

        it 'should call #possible_move?' do
          valid_move_game.instance_variable_set(:@travel_path, [1, 2])
          # allow(piece).to receive(:===).with(Knight).and_return(true)
          expect(valid_move_game).to receive(:possible_move?)
          valid_move_game.valid_move?(knight, [2, 2])
        end

        it 'should not call #impeding_piece?' do
          valid_move_game.instance_variable_set(:@travel_path, [1, 2])
          # allow(piece).to receive(:===).with(Knight).and_return(true)
          expect(valid_move_game).not_to receive(:impeding_piece?)
          valid_move_game.valid_move?(knight, [2, 2])
        end
      end

        context 'moving a pawn' do
          let(:white_pawn) { WhitePawn.new([6, 2]) }
          let(:black_pawn) { BlackPawn.new([1, 2]) }

          before do
            # allow(piece).to receive(:class).and_return(WhitePawn)
            allow(valid_move_game).to receive(:valid_pawn_move?)
          end

          it 'should call #valid_pawn_move? when moving a WhitePawn' do
            expect(valid_move_game).to receive(:valid_pawn_move?)
            valid_move_game.valid_move?(white_pawn, [2, 2])
          end

          it 'should call #valid_pawn_move? when moving a BlackPawn' do
            expect(valid_move_game).to receive(:valid_pawn_move?)
            valid_move_game.valid_move?(black_pawn, [2, 2])
          end
        end

        context 'moving a King' do
          let(:king) { King.new(:black, [0, 4]) }

          it 'should call #valid_king_move?' do
            expect(valid_move_game).to receive(:valid_king_move?)
            valid_move_game.valid_move?(king, [1, 4])
          end
        end

        context 'when moving piece is not a pawn, king, or knight' do
          let(:rook) { Rook.new(:white, [7, 0]) }

          before do
            allow(valid_move_game).to receive(:possible_move?).and_return(true)
            allow(valid_move_game).to receive(:impeding_piece?)
          end

          it 'should call #possible_move?' do
            expect(valid_move_game).to receive(:possible_move?)
            valid_move_game.valid_move?(rook, [4, 0])
          end

          it 'should also call #impeding_piece when #possible_move? is true' do
            expect(valid_move_game).to receive(:impeding_piece?)
            valid_move_game.valid_move?(rook, [4, 0])
          end
        end
      end

      describe '#valid_king_move?' do
        subject(:king_move_game) { described_class.new(king_move_board) }
        let(:king_move_board) { instance_double(Board) }
        let(:king) { instance_double(King, possible_moves: [[0, 1], [1, 1],
                                                            [1, 0], [1, -1],
                                                            [0, -1], [-1, -1],
                                                            [-1, 0], [-1, 1]],
                                           castling_moves: [[-2, 0], [2, 0]]) }
        let(:desired_space) { [1, 4] }

        context 'when a king attempts a standard one-space move' do
          it 'will call #impeding_piece?' do
            king_move_game.instance_variable_set(:@travel_path, [1, 0])
            expect(king_move_game).to receive(:impeding_piece?)
            king_move_game.valid_king_move?(king, king_move_game.travel_path, desired_space)
          end

          it 'will not call king.has_moved' do
            allow(king_move_board).to receive(:piece_exists?).and_return(false)
            allow(king).to receive(:current_location).and_return([1, 3])
            king_move_game.instance_variable_set(:@travel_path, [1, 0])
            expect(king).to_not receive(:has_moved)
            king_move_game.valid_king_move?(king, king_move_game.travel_path, desired_space)
          end
        end

        context 'when a king attempts to castle' do
          it 'will call king.has_moved' do
            king_move_game.instance_variable_set(:@travel_path, [-2, 0])
            expect(king).to receive(:has_moved)
            king_move_game.valid_king_move?(king, king_move_game.travel_path, desired_space)
          end

          it 'will not call #impeding_piece?' do
            allow(king).to receive(:has_moved)
            king_move_game.instance_variable_set(:@travel_path, [-2, 0])
            expect(king_move_game).to_not receive(:impeding_piece?)
            king_move_game.valid_king_move?(king, king_move_game.travel_path, desired_space)
          end
        end
      end

        describe '#valid_pawn_move?' do
          subject(:pawn_move_game) { described_class.new(pawn_move_board) }
          let(:pawn_move_board) { instance_double(Board) }
          let(:white_pawn) { instance_double(WhitePawn, possible_moves: [[0, 1], [0, 2]],
                                                        capture_moves: [[-1, 1], [1, 1]]) }


          it 'calls #valid_pawn_vertical_move? if possible_move?' do
            pawn_move_game.instance_variable_set(:@travel_path, [0, 2])
            expect(pawn_move_game).to receive(:valid_pawn_vertical_move?).with(white_pawn, [4, 3])
            pawn_move_game.valid_pawn_move?(white_pawn, pawn_move_game.travel_path, [4, 3])
          end

          it 'calls #valid_pawn_capture_move? if pawn_capture_move?' do
            pawn_move_game.instance_variable_set(:@travel_path, [-1, 1])
            expect(pawn_move_game).to receive(:valid_pawn_capture_move?).with(white_pawn, [4, 3])
            pawn_move_game.valid_pawn_move?(white_pawn, pawn_move_game.travel_path, [4, 3])
          end

          it 'returns false otherwise' do
            pawn_move_game.instance_variable_set(:@travel_path, [-1, -1])
            result = pawn_move_game.valid_pawn_move?(white_pawn, pawn_move_game.travel_path, [4, 3])
            expect(result).to be false
          end

          # it 'allows moving two spaces as first move' do
          #   pawn_move_game.instance_variable_set(:@travel_path, [0, 2])
          #   allow(pawn_move_board).to receive(:piece_exists?)
          #   allow(white_pawn_start).to receive(:current_location).and_return([6, 6])
          #   travel_path = pawn_move_game.travel_path
          #   desired_space = [4, 6]

          #   result = pawn_move_game.valid_pawn_move?(white_pawn_start, travel_path, desired_space)
          #   expect(result).to be true
          # end

          # it 'does not allow moving two spaces after first move' do
          #   allow(white_pawn_moved).to receive(:current_location).and_return([5, 6])
          #   travel_path = [0, 2]
          #   desired_space = [3, 6]
          #   result = pawn_move_game.valid_pawn_move?(white_pawn_moved, travel_path, desired_space)
          #   expect(result).to be false
          # end

          # xit 'does not allow vertical move if space is blocked' do
          #   @black_pawn = BlackPawn.new([5, 6])
          #   @board.board_array[5][6] = @black_pawn
          #   @game.travel_path = [0, 2]
          #   expect(@game.valid_pawn_move?(@white_pawn, [0, 2], [4, 6])).to be false
          # end

          # xit 'does not allow vertical move if space is blocked' do
          #   @black_pawn = BlackPawn.new([5, 6])
          #   @board.board_array[5][6] = @black_pawn
          #   @game.travel_path = [0, 2]
          #   expect(@game.valid_pawn_move?(@white_pawn, [0, 2], [4, 6])).to be false
          # end

          # xit 'does not allow capture move if no opponent on the space' do
          #   expect(@game.valid_pawn_move?(@white_pawn, [-1, 1], [5, 5])).to be false
          # end

          # xit 'does not allow horizontal/illegal move' do
          #   expect(@game.valid_pawn_move?(@white_pawn, [-1, 0], [6, 5])).to be false
          # end
        end

    describe '#pawn_promotion' do
      subject(:game_pawn_promo) { described_class.new(promotion_board) }
      let(:promotion_board) { instance_double(Board) }
      let(:new_piece) { instance_double(Queen) }

      before do
        game_pawn_promo.instance_variable_set(:@promotion, 'queen')
        game_pawn_promo.instance_variable_set(:@new_promoted_piece, new_piece)
        game_pawn_promo.instance_variable_set(:@end_space, [0, 2])
        allow(game_pawn_promo).to receive(:create_piece_for_promotion)
        allow(promotion_board).to receive(:add_new_promoted_piece_to_board).once
      end

      it 'sends #create_piece_for_promotion' do
        expect(game_pawn_promo).to receive(:create_piece_for_promotion).once
        game_pawn_promo.pawn_promotion(promotion_board)
      end

      it 'sends Board #add_new_promoted_piece_to_board' do
        expect(promotion_board).to receive(:add_new_promoted_piece_to_board).with([0, 2], new_piece)
        game_pawn_promo.pawn_promotion(promotion_board)
      end
    end

    # describe '#get_travel_path' do
    #   context 'when moving piece from [7, 6] to [5, 4]' do
    #     let(:bishop) { instance_double(Bishop, color: 'black', current_location: [7, 6]) }
    #     let(:board) { instance_double(Board) }
    #     let(:game) {instance_double(Game, gameboard: board) }
    #     it 'should have travel_path of [-2, 2]' do
    #       # bishop = Bishop.new('black', [7, 6])
    #       allow(:board).to receive(:board_array[7][6]).and_return(:bishop)
    #       # board.board_array[7][6] = bishop
    #       game.get_travel_path(bishop, [5, 4])
    #       expect(game.travel_path).to eq([-2, 2])
    #     end
    #   end
    # end

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

        # describe '#valid_pawn_move?' do
        #   it 'should return true when white can white_can_en_passant' do
        #     @black_pawn.initial_turn = 8
        #     @game.total_turn_counter = 9
        #     @game.travel_path = [-1, 1]
        #     travel_path = [-1, 1]
        #     expect(@game.valid_pawn_move?(@white_pawn, travel_path, [2, 6])).to be true
        #   end
        # end
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

        describe '#first_move_for_pawn' do
          it 'is called by move piece' do
            @game.end_space = [4, 6]
            expect(@white_pawn).to receive(:makes_first_move).once
            @game.move_piece(@white_pawn, [4, 6])
          end

          it 'removes [0, 2] from possible_moves' do
            @game.total_turn_counter = 3
            @game.first_move_for_pawn(@white_pawn, [4, 6])
            expect(@white_pawn.possible_moves).to_not include([0, 2])
          end

          it 'sets initial_turn to current turn count if pawn moves two' do
            @game.total_turn_counter = 3
            @game.first_move_for_pawn(@white_pawn, [4, 6])
            expect(@white_pawn.initial_turn).to eq(3)
          end

          it ' does not set initial_turn if pawn only moves one' do
            @game.total_turn_counter = 3
            @game.first_move_for_pawn(@white_pawn, [5, 6])
            expect(@white_pawn.initial_turn).to eq(0)
          end
        end
      end

    describe '#impeding_piece?' do
      it 'should be true when ally is on the destination square' do
        pawn_ally = WhitePawn.new([7, 4])
        @board.board_array[7][4] = pawn_ally
        @game.travel_path = [-3, 0]
        expect(@game.impeding_piece?(@rook_h1, [7, 4])).to be true
      end
      
      it 'should be false when opponent is on the destination square' do
        pawn_opponent = BlackPawn.new([7, 5])
        @board.board_array[7][5] = pawn_opponent
        @game.travel_path = [-2, 0]
        expect(@game.impeding_piece?(@rook_h1, [7, 5])).to be false
      end

      describe '#horizontal_impediment?' do
        before(:each) do
          @white_pawn_h = WhitePawn.new([6, 7])
          @board.board_array[6][7] = @white_pawn_h
          @white_pawn_g = WhitePawn.new([6, 6])
          @board.board_array[6][6] = @white_pawn_g
        end

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
            rook_a1 = Rook.new(:white, [7, 0])
            expect(@game.horizontal_impediment?(rook_a1, [5, 0])).to be true
          end
        end
      end

      describe '#vertical_impediment?' do
        before(:each) do
          @white_knight_g = Knight.new(:white, [7, 6])
          @board.board_array[7][6] = @white_knight_g
          @white_pawn_g = WhitePawn.new([6, 6])
          @board.board_array[6][6] = @white_pawn_g
        end

        # @rook_h1 white, 7,7
        it 'should be false when there is no piece in the way' do
          expect(@game.vertical_impediment?(@rook_h1, [0, 4])).to be false
        end

        context 'when moving towards an ally' do
          before(:each) do
            @pawn_ally = WhitePawn.new([5, 7])
            @board.board_array[5][7] = @pawn_ally
          end

          it 'should be true when ally is in the way - positive check' do
            expect(@game.vertical_impediment?(@rook_h1, [0, 4])).to be true
          end

          it 'should be true when ally is in the way - negative check' do
            rook = Rook.new(:white, [4, 7])
            @board.board_array[4][7] = rook
            expect(@game.vertical_impediment?(rook, [0, -2])).to be true
          end
        end
      end

      describe '#diagonal_impediment?' do
        before(:each) do
          @white_bishop = Bishop.new(:white, [7, 5])
          @board.board_array[7][5] = @white_bishop
          @white_knight_g = Knight.new(:white, [7, 6])
          @board.board_array[7][6] = @white_knight_g
          @white_pawn_f = WhitePawn.new([6, 5])
          @board.board_array[6][5] = @white_pawn_f
          @white_king = King.new(:white, [7, 4])
          @board.board_array[7][4] = @white_king
          @black_bishop = Bishop.new(:black, [0, 5])
          @board.board_array[0][5] = @black_bishop
          @black_knight_g = Knight.new(:black, [0, 6])
          @board.board_array[0][6] = @black_knight_g
          @black_pawn_f = BlackPawn.new([1, 5])
          @board.board_array[1][5] = @black_pawn_f
          @black_king = King.new(:black, [0, 4])
          @board.board_array[0][4] = @black_king
        end

        # @rook_h1 white, 7,7
        it 'should be false when there is no piece in the way' do
          expect(@game.diagonal_impediment?(@white_bishop, [-2, 2])).to be false
        end

        context 'when moving towards an ally' do
          # before(:each) do
          #   @pawn_ally = WhitePawn.new([6, 4])
          #   @board.board_array[6][4] = @pawn_ally
          # end

          it 'should be true when ally is in the way - Q1 check' do
            pawn_ally = WhitePawn.new([6, 6])
            @board.board_array[6][6] = pawn_ally
            expect(@game.diagonal_impediment?(@white_bishop, [2, 2])).to be true
          end

          it 'should be true when ally is in the way - Q2 check' do
            pawn_ally = WhitePawn.new([6, 4])
            @board.board_array[6][4] = pawn_ally
            expect(@game.diagonal_impediment?(@white_bishop, [-2, 2])).to be true
          end

          it 'should be true when ally is in the way - Q3 check' do
            pawn_ally = BlackPawn.new([1, 4])
            @board.board_array[1][4] = pawn_ally
            expect(@game.diagonal_impediment?(@black_bishop, [-2, -2])).to be true
          end

          it 'should be true when ally is in the way - Q3 check' do
            pawn_ally = BlackPawn.new([1, 6])
            @board.board_array[1][6] = pawn_ally
            expect(@game.diagonal_impediment?(@black_bishop, [2, -2])).to be true
          end
        end
      end
    end

    describe '#in_check?' do
      describe '#knight_check?' do
        before(:each) do
          @black_king = King.new(:black, [0, 4])
          @board.board_array[0][4] = @black_king
        end

        context 'when no enemy knight in range' do
          it 'is not check' do
            expect(@game.in_check?(@black_king)).to be false
          end
        end

        context 'when knight is one move away' do
          it 'is not check when the knight is an ally' do
            black_knight = Knight.new(:black, [1, 2])
            @board.board_array[1][2] = black_knight
            expect(@game.in_check?(@black_king)).to be false
          end

          it 'is check when then knight is an enemy' do
            white_knight = Knight.new(:white, [1, 2])
            @board.board_array[1][2] = white_knight
            expect(@game.in_check?(@black_king)).to be true
          end
        end
      end
    end

    context "when attempting to castle" do
      before(:each) do
          @white_king = King.new(:white, [7, 4])
          @board.board_array[7][4] = @white_king
          @white_rook_h = Rook.new(:white, [7, 7])
          @board.board_array[7][7] = @white_rook_h
          @game.end_space = [7, 6]
          @game.define_castling_mappings
        end
     
      describe '#no_castling_impediments' do
        it 'should be true when no pieces between the rook and king' do
          expect(@game.no_castling_impediments?([7, 6])).to be true
        end

        it 'should be false when piece(s) between the rook and king' do
          @white_bishop = Bishop.new(:white, [7, 5])
          @board.board_array[7][5] = @white_bishop
          expect(@game.no_castling_impediments?([7, 6])).to be false
        end
      end

    #   describe '#copy_castling_spaces' do # combine with above castling tests?
    #     context 'when castling white king to G1' do
    #       # it 'rook_start_copy should be copy of board_array[7][7]' do
    #       #   @game.copy_castling_spaces
    #       #   expect(@game.rook_start_copy).to eq(@board.board_array[7][7])
    #       # end

    #       it 'rook_end_copy should be copy of board_array[7][5]' do
    #         @game.copy_castling_spaces
    #         expect(@game.rook_end_copy).to eq(@board.board_array[7][5])
    #       end
    #     end
    #   end

    #   describe '#restore_castling_copies' do # combine with above castling tests?
    #     context 'when castling white king to G1' do
    #       it 'board_array[7][5] should be set back to an empty space' do
    #         @game.copy_castling_spaces
    #         @game.gameboard.board_array[7][5] = 'broken'
    #         @game.restore_castling_copies
    #         expect(@board.board_array[7][5]).to eql('__')
    #       end

    #       it 'board_array[7][7] should be set back to rook_start_copy' do
    #         @game.copy_castling_spaces
    #         #@game.gameboard.board_array[7][7] = '__'
    #         @game.restore_castling_copies
    #         expect(@game.gameboard.board_array[7][7]).to eq(@game.rook_start_copy)
    #       end

    #       it 'board_array[7][7] should be set back to a rook' do
    #         @game.copy_castling_spaces
    #         @game.gameboard.board_array[7][7] = '__'
    #         @game.restore_castling_copies
    #         expect(@game.gameboard.board_array[7][7].class).to eq(Rook)
    #       end
    #     end
    #   end
    end

    # describe '#copy_castling_spaces' do # combine with above castling tests?
    #   before(:each) do
    #     @white_king = King.new('white', [7, 4])
    #     @board.board_array[7][4] = @white_king
    #     @white_rook_h = Rook.new('white', [7, 7])
    #     @board.board_array[7][7] = @white_rook_h
    #     @game.end_space = [7, 6]
    #     @game.define_castling_mappings
    #   end

    #   it 'rook_start_copy should be copy of board_array[7][7]' do
    #     @game.copy_castling_spaces
    #     expect(@game.rook_start_copy).to eq(@board.board_array[7][7])
    #   end

    #   it 'rook_end_copy should be copy of board_array[7][5]' do
    #     @game.copy_castling_spaces
    #     expect(@game.rook_end_copy).to eq(@board.board_array[7][5])
    #   end
    # end
    

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
        expect(@board.board_array[7][7]).to eq('_') # comment line to use with WSL
        # expect(@board.board_array[7][7]).to eq('__') # uncomment line to use with WSL
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
        bishop_f1 = Bishop.new(:black, [7, 5])
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
