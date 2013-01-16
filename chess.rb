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
end

class Board
  attr_accessor :chess_board

  def initialize
    @chess_board = create_board
  end

  def pretty_print
    @chess_board.each do |row|
      puts "|" + row.join("   ") + "|"
      puts "-----------------------"
    end
  end

  def create_board
    board = []
    8.times do
      board << Array.new(8)
    end
    board
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
  def can_check?

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


