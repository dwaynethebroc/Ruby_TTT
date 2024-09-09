class Game
  @@total_wins = 0
  @@total_losses = 0
  @@total_ties = 0

  def self.check_win
  
  end

  def self.game_turn

    player1.choose_placement(board)
    board.display_board

    player2.choose_placement(board)
    board.display_board
  end
end

class Player < Game

  attr_reader :name, :token

  def initialize(name, token)
    @name = name
    @token = token
    @wins = 0
    @losses = 0
    @ties = 0
  end

  def choose_placement(game_board)
    'Choose a number between 1-9 to choose index'
    player_choice = gets.chomp.to_i - 1

    row = (player_choice / 3).floor
    column = (player_choice % 3).floor

    if @board[row][column] == '-'
      game_board.update_board(player_choice, @token)
      game_board.display_board
    end 
    
  end
end

class Board < Game

  attr_accessor :board

  def initialize
    @board = [['-', '-', '-'], 
              ['-', '-', '-'], 
              ['-', '-', '-']]
  end

  def display_board
    @board.each do |row|
      puts row.each { |position| position }.join(" ")
    end
  end

  def update_board(player_choice, token)
    row = (player_choice / 3).floor
    column = (player_choice % 3).floor

    @board[row][column] = token
  end
end



player1 = Player.new('Player 1', 'X')
player2 = Player.new('Player 2', 'O')

board = Board.new

player1.choose_placement(board)