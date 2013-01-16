# encoding: utf-8
# require "debugger"

# Here is the game logic
class Game
  attr_accessor :board

  def initialize
    @board = Board.new
  end

  def save_game
    puts "Save your game!"
    print "What do you want to save your game as? >"
    save_game = gets.chomp
    File.open("#{save_game}.chess", "w") do |file|
      file.write(self.to_yaml)
    end
  end

  def self.load_game
    puts "Load yo game!"
    print "What is your game saved as? >"
    saved_game = gets.chomp
    file = File.readlines("#{saved_game}.chess").join
    YAML.load(file)
  end

  def play_loop

  end

  def get_input

  end

  def move(source_row, source_col, target_row, target_col)
    moving_piece = @board.piece_at(source_row, source_col)
    @board.piece_at(target_row,target_col,moving_piece)
    @board.piece_at(source_row,source_col,:blank)
    @board.pretty_print #debug
  end
end

class Board
  attr_accessor :grid #for debugging

  def initialize
    @grid = create_board
    populate_board
    pretty_print
  end

  def pretty_print
    puts "   A B C D E F G H"
    puts "   ---------------"
    @grid.each_with_index do |row, row_index|
      print "#{row_index + 1}| "
      row.each_with_index do |cell, col_index|
        piece = piece_at(row_index, col_index)
        unless piece == :blank
          print piece.icon + " "
        else
          print "_ "
        end
      end
      puts
    end
    nil
  end

  def create_board
    board = []
    8.times do
      board << Array.new(8, :blank)
    end
    board
  end

  def populate_board
    # black pawns
    @grid[1].each_with_index do |cell, i|
      piece_at(1, i, Pawn.new(:black))
    end
    # white pawns
    @grid[6].each_with_index do |cell, i|
      piece_at(6, i, Pawn.new(:white))
    end
    #black rooks
    piece_at(0,0, Rook.new(:black))
    piece_at(0,7, Rook.new(:black))
    #white rooks
    piece_at(7,0, Rook.new(:white))
    piece_at(7,7, Rook.new(:white))
    #black knights
    piece_at(0,1, Knight.new(:black))
    piece_at(0,6, Knight.new(:black))
    #white knights
    piece_at(7,1, Knight.new(:white))
    piece_at(7,6, Knight.new(:white))
    #black bishops
    piece_at(0,2, Bishop.new(:black))
    piece_at(0,5, Bishop.new(:black))
    #white bishops
    piece_at(7,2, Bishop.new(:white))
    piece_at(7,5, Bishop.new(:white))
    #black royals
    piece_at(0,3, Queen.new(:black))
    piece_at(0,4, King.new(:black))
    #white royals
    piece_at(7,3, Queen.new(:white))
    piece_at(7,4, King.new(:white))
  end

  def piece_at(row, col, value = nil)
    unless value == nil
      @grid[row][col] = value
    else
      @grid[row][col]
    end
  end

end

class Player
end

# Here are the Players
class HumanPlayer < Player
end

class ComputerPlayer < Player
end

# Here are the Pieces
class Piece
  ICONS = {
    :white => {
      king: "♔",
      queen: "♕",
      rook: "♖",
      bishop: "♗",
      knight: "♘",
      pawn: "♙"
    },
    :black => {
      king: "♚",
      queen: "♛",
      rook: "♜",
      bishop: "♝",
      knight: "♞",
      pawn: "♟"
    }
  }

  attr_accessor :color, :icon

  def initialize(color)
    @color = color
    # This ugly bit of code assigns icons to each class automatically
    @icon = ICONS[color][self.class.to_s.downcase.to_sym]
  end

  def can_check?

  end

  def move

  end

end

class Knight < Piece

end

class King < Piece

end

class Queen < Piece

end

class Rook < Piece

end

class Bishop < Piece

end

class Pawn < Piece

end


