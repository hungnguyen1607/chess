require_relative 'board'
require_relative 'piece'
require 'yaml'
class Game
  FILES = %w[a b c d e f g h].freeze

  def initialize
    @board = Board.new
    @board.setup
    @current_color = :white
    @ai_enabled = true
  end

  def start
    loop do
      system('clear') || system('cls')
      display_board
      from, to = prompt_move
      next unless from && to

      if perform_move(from, to)
        switch_turn
        if @board.checkmate?(@current_color)
          puts "Checkmate! #{@current_color} loses!"
          break
        elsif @board.in_check?(@current_color)
          puts "Check! #{@current_color} is in check!"
        end
        # If AI is enabled and it's the AI's turn, perform AI move
        if @ai_enabled && @current_color == :black
          ai_move
          switch_turn
        end
      else
        prompt_continue
      end
    end
  end

  private

  def display_board
    puts "Turn: #{@current_color.capitalize}"
    @board.display
  end

  def prompt_move
    print 'Enter move (e.g. e2 e4): '
    input = gets&.strip
    return unless input

    if input.downcase == 'save'
      save_game
      return
    elsif input.downcase == 'load'
      load_game
      return
    end
    
    parts = input.split
    if parts.size == 2
      parts
    else
      puts 'Please enter exactly two squares like: e2 e4'
      nil
    end
  end

  def perform_move(from, to)
    from_row, from_col = parse_square(from)
    to_row, to_col = parse_square(to)
    return false unless from_row && to_row

    piece = @board.piece_at(from_row, from_col)
    unless piece
      puts "No piece at #{from}."
      return false
    end

    unless piece.color == @current_color
      puts "That is not your piece."
      return false
    end

    unless @board.in_bounds?(to_row, to_col)
      puts "Destination #{to} is out of bounds."
      return false
    end

    @board.move_piece(from_row, from_col, to_row, to_col)
    true
  rescue StandardError => e
    puts "Move error: #{e.message}"
    false
  end

  def parse_square(square)
    return unless square
    s = square.downcase.strip
    return unless s =~ /\A([a-h])([1-8])\z/

    file = Regexp.last_match(1)
    rank = Regexp.last_match(2).to_i
    row = 8 - rank
    col = FILES.index(file)
    [row, col]
  end

  def square_name(row, col)
    file = FILES[col]
    rank = 8 - row
    "#{file}#{rank}"
  end

  def ai_move
    moves = []
    @board.positions_for_color(:black).each do |r, c|
      @board.possible_moves_from(r, c).each do |dr, dc|
        moves << [r, c, dr, dc]
      end
    end
    return if moves.empty?

    from_r, from_c, to_r, to_c = moves.sample
    @board.move_piece(from_r, from_c, to_r, to_c)
    puts "AI moves from #{square_name(from_r, from_c)} to #{square_name(to_r, to_c)}"
    sleep 0.5
  end

  def switch_turn
    @current_color = @current_color == :white ? :black : :white
  end

  def prompt_continue
    print 'Press Enter to continue...'
    gets
  end

  def in_check?
    @board.in_check?(@current_color)
  end


  def save_game
    File.open('chess_save.yml', 'w') do |file|
      file.write(YAML.dump({
        board: @board,
        current_color: @current_color,
        ai_enabled: @ai_enabled
      }))
    end
    puts 'Game saved to chess_save.yml'
  end

  def load_game
    if File.exist?('chess_save.yml')
      data = YAML.load_file('chess_save.yml')
      @board = data[:board]
      @current_color = data[:current_color]
      @ai_enabled = data[:ai_enabled]
      puts 'Game loaded from chess_save.yml'
    else
      puts 'No saved game found.'
    end
  end
end
