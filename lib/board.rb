require_relative 'piece'

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8, nil) }
  end

  def setup
    back_rank = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

    back_rank.each_with_index do |piece_class, col|
      place_piece(piece_class.new(:black), 0, col)
      place_piece(piece_class.new(:white), 7, col)
    end

    8.times do |col|
      place_piece(Pawn.new(:black), 1, col)
      place_piece(Pawn.new(:white), 6, col)
    end
  end

  def place_piece(piece, row, col)
    @grid[row][col] = piece
  end

  def piece_at(row, col)
    @grid[row][col]
  end

  # Return array of [row, col] for pieces of the given color
  def positions_for_color(color)
    positions = []
    @grid.each_with_index do |row_arr, r|
      row_arr.each_with_index do |cell, c|
        positions << [r, c] if cell && cell.color == color
      end
    end
    positions
  end

  # Very simple move generator: all in-bounds squares that are not
  # occupied by the same color. This is intentionally permissive
  # (doesn't enforce piece-specific movement rules) and will be
  # refined later for full legality checks.
  def possible_moves_from(row, col)
    piece = piece_at(row, col)
    return [] unless piece

    moves = []
    (0..7).each do |r|
      (0..7).each do |c|
        next if r == row && c == col
        next if piece_at(r, c) && piece_at(r, c).color == piece.color
        moves << [r, c]
      end
    end
    moves
  end

  def move_piece(from_row, from_col, to_row, to_col)
    piece = piece_at(from_row, from_col)
    raise 'No piece to move' unless piece

    @grid[to_row][to_col] = piece
    @grid[from_row][from_col] = nil
  end

  def in_bounds?(row, col)
    row.between?(0, 7) && col.between?(0, 7)
  end

  def display
    puts '  a b c d e f g h'
    @grid.each_with_index do |row, index|
      rank = 8 - index
      row_data = row.map { |cell| cell ? cell.to_s : '.' }.join(' ')
      puts "#{rank} #{row_data}"
    end
  end
end

