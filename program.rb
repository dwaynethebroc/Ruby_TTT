class Game
  @@total_wins = 0
  @@total_losses = 0
  @@total_ties = 0

  @@win? = false
  @@tie? = false

  def self.check_win_tie(board)
    row = i
    col = j

    if row


  def self.game_turn(player1, player2, board)

    player1.choose_placement(board)
    check_win_tie(board)


    player2.choose_placement(board)
    check_win_tie(board)

    if @@win? == false && @@tie == false
      game_turn(player1, player2, board)
    end
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

    game_board.display_board

    input = nil
    
    until input =~ /^[1-9]$/
      puts 'Choose a number between 1-9 to choose index: '
      input = gets.chomp
    end

    player_choice = input.to_i - 1

    row = (player_choice / 3).floor
    column = (player_choice % 3).floor

    if player_choice.between?(0, 8) && game_board.board[row][column] == '-'
      game_board.update_board(player_choice, @token)
      game_board.display_board
    else
      puts "Invalid position or position already taken. Choose another."
      choose_placement(game_board)
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

Game.game_turn(player1, player2, board)