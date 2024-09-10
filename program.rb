class Game
  @@total_games = 0
  @@wins_player_one = 0
  @@wins_player_two = 0

  @@win? = false
  @@tie? = false

  def self.scoreBoard
    puts "Total games played: #{@@total_games} \n
          Player 1's score: #{@@wins_player_one}\n
          Player 2's score: #{@@wins_player_two}\n
          Number of ties: #{@@total_games - @@wins_player_one - @@wins_player_two}"
  end

  def self.check_win_tie(board)
    #Check rows
    board.board.each do |row|
      if row.uniq.length == 1 && row.first != '-'
        @@win? = true
        return
      end
    end

    #Check columns
    (0..2).each do |col|
      column = [board.board[0][col], board.board[1][col], board.board[2][col]]
      if column.uniq.length == 1 && column.first != '-'
        @@win? = true
        return
    end

    #Check diagonols

    diaganol1 = [board.board[0][0], board.board[1][1], board.board[2][2]]

    if diaganol1.uniq.length == 1 && board.board[0][0] != '-' 
      @@win? = true
      return
    end

    diaganol2 = [board.board[0][2], board.board[1][1], board.board[2][0]]
    
    if diaganol2.uniq.length == 1 && board.board[0][2] != '-'
      @@win? = true
      return
    end

    #Check for tie
    if board.board.flatten.none? {|position| position == '-'}
      @@tie? = true
    end
  end

  def self.game_reset
    @@win? = false
    @@tie? = false

    total_games += 1
  end

  def self.game_turn(player1, player2, board)

    #player1 goes and checks to see if they won
    player1.choose_placement(board)
    check_win_tie(board)

    if @@win? == true && @@tie? == false
      puts "Player 1 is the winner!"
      @@wins_player_one += 1
    end

    #player 2 goes and checks to see if they won
    player2.choose_placement(board)
    check_win_tie(board)

    if @@win? == true && @@tie? == false
      puts "Player 2 is the winner"
      @@wins_player_two += 1
    end

    #is it a tie?

    if @@win? == false and @@tie? == true
      puts "Game is a tie! Nobody wins!"
    end
    #if neither won this turn and it's not a tie, start next turn


    if @@win? == false && @@tie? == false
      game_turn(player1, player2, board)

    else 
      self.game_reset
    end 
  end
end

class Player < Game

  attr_reader :name, :token

  def initialize(name, token)
    @name = name
    @token = token
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

  def winner
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