# encoding: utf-8
# require "debugger"

# Here is the game logic
class Game
  attr_accessor :board

  def initialize
    @board = Board.new
  end

  # DELETE ME LATER !!!!!
  # CHEATCODEZ DEV OPTIONS
  def dprint
    @board.pretty_print_dev
  end

  def dp(row, col)
    @board.piece_at(row, col)
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

  def change_position(source_row, source_col, target_row, target_col)
    moving_piece = @board.piece_at(source_row, source_col)
    @board.piece_at(target_row,target_col,moving_piece)
    @board.piece_at(source_row,source_col,:blank)
    @board.pretty_print #debug
  end

  def move(source_row, source_col, target_row, target_col)
    # IF there's a piece
    if @board.piece_at(target_row,target_col).is_a?(Piece)
      piece = take_piece(target_row,target_col)
      # Save piece to somewhere -- going to be a player array
      # snatch(piece)
    end
    # Move position
    change_position(source_row, source_col, target_row, target_col)
  end

  def take_piece(target_row,target_col)
    target_piece = @board.piece_at(target_row,target_col)
    #removes the piece
    @board.piece_at(target_row,target_col, :blank)
    target_piece
  end
end

class Board
  attr_accessor :grid #for debugging

  def initialize
    @grid = create_board
    populate_board
    pretty_print_dev
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

  def pretty_print_dev
    puts "   0 1 2 3 4 5 6 7"
    puts "   ---------------"
    @grid.each_with_index do |row, row_index|
      print "#{row_index}| "
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
    8.times { board << Array.new(8, :blank) }
    board
  end

  def populate_board
    # black pawns
    @grid[1].each_with_index do |cell, i|
      piece_at(1, i, Pawn.new(:black, self))
    end
    # white pawns
    @grid[6].each_with_index do |cell, i|
      piece_at(6, i, Pawn.new(:white, self))
    end
    #black rooks
    piece_at(0,0, Rook.new(:black, self))
    piece_at(0,7, Rook.new(:black, self))
    #white rooks
    piece_at(7,0, Rook.new(:white, self))
    piece_at(7,7, Rook.new(:white, self))
    #black knights
    piece_at(0,1, Knight.new(:black, self))
    piece_at(0,6, Knight.new(:black, self))
    #white knights
    piece_at(7,1, Knight.new(:white, self))
    piece_at(7,6, Knight.new(:white, self))
    #black bishops
    piece_at(0,2, Bishop.new(:black, self))
    piece_at(0,5, Bishop.new(:black, self))
    #white bishops
    piece_at(7,2, Bishop.new(:white, self))
    piece_at(7,5, Bishop.new(:white, self))
    #black royals
    piece_at(0,3, Queen.new(:black, self))
    piece_at(0,4, King.new(:black, self))
    #white royals
    piece_at(7,3, Queen.new(:white, self))
    piece_at(7,4, King.new(:white, self))

    #test pawns
    piece_at(3, 3, Pawn.new(:white, self))
    piece_at(3, 4, Pawn.new(:black, self))
  end

  def piece_at(row, col, value=nil)
    unless value == nil
      @grid[row][col] = value
      value.position(row,col) unless value == :blank
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

  attr_accessor :color, :icon, :position, :board

  def initialize(color,board)
    @color = color
    # This ugly bit of code assigns icons to each class automatically
    @icon = ICONS[color][self.class.to_s.downcase.to_sym]
    @board = board
  end

  def position(row=nil,col=nil)
    unless row.nil? && col.nil?
      @position = [row,col]
    end
    @position
  end

  def can_check?

  end

  def valid_move?(target_position)
    valid_moves.include?(target_position)
  end

  def valid_moves
    all_moves = self.class::POS_MOVES.map do |(row,col)|
      [@position[0] + row, @position[1] + col]
    end

    all_moves = remove_non_existant_moves(all_moves)
    all_moves = remove_team_occupied_moves(all_moves)
  end

  def remove_non_existant_moves(moves)
    coordinates = moves.select do |(row, col)|
      [row, col].all? do |coord|
        (0...7).include?(coord)
      end
    end

    coordinates
  end

  def remove_team_occupied_moves(moves)
    moves.select do |(row, col)|
      piece = @board.piece_at(row,col)
      if piece == :blank || piece.color != self.color
        true
      else
        false
      end
    end
  end

end

class Knight < Piece
  POS_MOVES = [
    [-2, -1],
    [-2, 1],
    [1, 2],
    [1, -2],
    [2, 1],
    [2, -1],
    [-1, 2],
    [-1, -2]
  ]
end

class King < Piece
  POS_MOVES = [
    [-1, -1],
    [-1, 0],
    [-1, 1],
    [0, -1],
    [0, 1],
    [1, -1],
    [1, 0],
    [1, 1]
  ]

end

class Queen < Piece

end

class Rook < Piece

end

class Bishop < Piece

end

class Pawn < Piece
  POS_MOVES = [
    [1,0], # black
    [2,0], # black
    [1,1], # black
    [1,-1],# black
    [-1,0], # white
    [-2,0], # white
    [-1,-1], # white
    [-1,1] # white
  ]

  def valid_moves
    all_moves = super
    if self.color == :black
      all_moves.select! do |coords|
        coords[0] > self.position[0]
      end
      all_moves
    else # :white
      all_moves.select! do |coords|
        coords[0] < self.position[0]
      end
      all_moves
    end
  end
end

def game
  g = Game.new
  g
end
