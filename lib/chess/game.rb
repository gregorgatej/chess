module Chess
  class Game
    attr_reader :board, :player_white, :player_black

    def initialize
      @board = Board.new
      @player_white = Player.new(:white)
      @player_black = Player.new(:black)
    end

    def play
      current_player = player_white

      loop do
        puts "\n#{board}"
        puts "#{current_player}'s turn"
        puts "Enter move (e.g., '4,6 4,4' for col,row from-to) or 'exit' to quit:"

        input = gets.chomp
        break if input == "exit"
        
        input = input.split
        next unless valid_input?(input)

        from = input[0].split(",").map(&:to_i)
        to = input[1].split(",").map(&:to_i)

        # Convert from col,row to row,col for internal use
        from = [from[1], from[0]]
        to = [to[1], to[0]]

        unless board.valid_move?(from, to, current_player)
          puts "Invalid move!"
          next
        end

        board.move_piece(from, to)
        current_player = current_player == player_white ? player_black : player_white
      end
    end

    private

    def valid_input?(input)
      input.length == 2 && input.all? { |pos| pos.split(",").length == 2 }
    end
  end
end
