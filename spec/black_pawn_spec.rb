# frozen_string_literal: false

require 'pry'
require_relative '../lib/pieces/black_pawn'

describe BlackPawn do
  describe '#makes_first_move' do
    subject(:black_pawn) { described_class.new([1, 3]) }
    let(:move_number) { 3 } 

    it 'should set possible_moves = [[0, -1]]' do
      black_pawn.makes_first_move([3, 3], move_number)
      result = black_pawn.possible_moves
      expect(result).to eq([[0, -1]])
    end

    it 'should update initital_turn when moving two spaces' do
      black_pawn.makes_first_move([3, 3], move_number)
      result = black_pawn.initial_turn
      expect(result).to eq(move_number)
    end

    it 'should not update initital_turn when moving one space' do
      black_pawn.makes_first_move([2, 3], move_number)
      result = black_pawn.initial_turn
      expect(result).to eq(0)
    end
  end
end