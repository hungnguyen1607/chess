require 'spec_helper'

describe Piece do
  it 'requires child classes to define symbol' do
    expect { Piece.new(:white).symbol }.to raise_error(NotImplementedError)
  end
end

describe Pawn do
  it 'uses the white pawn symbol for white' do
    expect(Pawn.new(:white).to_s).to eq('♙')
  end

  it 'uses the black pawn symbol for black' do
    expect(Pawn.new(:black).to_s).to eq('♟')
  end
end

describe Rook do
  it 'uses the white rook symbol for white' do
    expect(Rook.new(:white).to_s).to eq('♖')
  end
end

describe Knight do
  it 'uses the black knight symbol for black' do
    expect(Knight.new(:black).to_s).to eq('♞')
  end
end

describe Bishop do
  it 'uses the white bishop symbol for white' do
    expect(Bishop.new(:white).to_s).to eq('♗')
  end
end

describe Queen do
  it 'uses the black queen symbol for black' do
    expect(Queen.new(:black).to_s).to eq('♛')
  end
end

describe King do
  it 'uses the white king symbol for white' do
    expect(King.new(:white).to_s).to eq('♔')
  end
end
