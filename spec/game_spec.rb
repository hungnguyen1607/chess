require 'spec_helper'

describe Game do
  let(:game) { Game.new }

  it 'starts with white to move' do
    expect(game.instance_variable_get(:@current_color)).to eq(:white)
  end

  it 'parses algebraic squares' do
    expect(game.send(:parse_square, 'e2')).to eq([6, 4])
    expect(game.send(:parse_square, 'a8')).to eq([0, 0])
  end

  it 'performs a valid pawn move' do
    expect(game.send(:perform_move, 'e2', 'e4')).to eq(true)
    expect(game.instance_variable_get(:@board).piece_at(6, 4)).to be_nil
    expect(game.instance_variable_get(:@board).piece_at(4, 4)).to be_a(Pawn)
  end

  it 'rejects moves from an empty square' do
    expect(game.send(:perform_move, 'e3', 'e4')).to eq(false)
  end

  it 'ai performs a move when requested' do
    board = game.instance_variable_get(:@board)
    initial = board.positions_for_color(:black).dup
    game.send(:ai_move)
    after = board.positions_for_color(:black)
    expect(after).not_to eq(initial)
  end
end
