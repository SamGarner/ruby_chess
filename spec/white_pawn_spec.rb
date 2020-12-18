# frozen_string_literal: false

require 'pry'
require_relative '../lib/pieces/white_pawn'

describe WhitePawn do
  describe '#makes_first_move' do
    subject(:white_pawn) { described_class.new([6, 3]) }
    let(:move_number) { 3 } 

    it 'should set possible_moves = [[0, 1]]' do
      white_pawn.makes_first_move([5, 3], move_number)
      result = white_pawn.possible_moves
      expect(result).to eq([[0, 1]])
    end

    it 'should update initital_turn when moving two spaces' do
      white_pawn.makes_first_move([4, 3], move_number)
      result = white_pawn.initial_turn
      expect(result).to eq(move_number)
    end

    it 'should not update initital_turn when moving one space' do
      white_pawn.makes_first_move([5, 3], move_number)
      result = white_pawn.initial_turn
      expect(result).to_not eq (move_number)
    end
  end
end