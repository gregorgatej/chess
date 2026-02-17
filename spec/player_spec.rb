require_relative "../lib/chess"

describe Chess::Player do
  subject(:player) { described_class.new(:white) }

  describe "#initialize" do
    it "creates a player with a color" do
      expect(player.color).to eq(:white)
    end
  end

  describe "#to_s" do
    it "returns capitalized color with 'Player'" do
      expect(player.to_s).to eq("White Player")
    end
  end
end

describe Chess::ComputerPlayer do
  subject(:computer) { described_class.new(:black) }
  let(:board) { Chess::Board.new }

  describe "#initialize" do
    it "inherits from Player and has a color" do
      expect(computer).to be_a(Chess::Player)
      expect(computer.color).to eq(:black)
    end

    it "has the same to_s behavior as Player" do
      expect(computer.to_s).to eq("Black Player")
    end
  end

  describe "#make_move" do
    it "returns a hash with :from and :to keys" do
      move = computer.make_move(board)
      expect(move).to be_a(Hash)
      expect(move.keys).to include(:from, :to)
    end

    it "returns a legal move for black" do
      move = computer.make_move(board)
      from = move[:from]
      to = move[:to]

      expect(board.state[from[0]][from[1]]).to be_a(Chess::Piece)
      expect(board.state[from[0]][from[1]].color).to eq(:black)
      expect(board.valid_move?(from, to, computer)).to be true
    end

    it "returns different moves on successive calls (randomness)" do
      moves = 10.times.map { computer.make_move(board) }
      # Check that we got at least 2 different move positions
      unique_moves = moves.map { |m| [m[:from], m[:to]] }.uniq
      expect(unique_moves.length).to be > 1
    end

    it "does not return moves that leave the king in check" do
      10.times do
        move = computer.make_move(board)
        from = move[:from]
        to = move[:to]
        
        expect(board.move_leaves_king_in_check?(from, to, computer)).to be false
      end
    end

    it "raises an exception if no legal moves available" do
      # Clear the board
      board.state = Array.new(8) { Array.new(8, nil) }
      
      black_king = Chess::King.new(:black)
      board.state[4][4] = black_king
      
      # Surround the king with white queens to attack all adjacent squares
      board.state[3][3] = Chess::Queen.new(:white)
      board.state[5][3] = Chess::Queen.new(:white)
      board.state[5][5] = Chess::Queen.new(:white)

      expect { computer.make_move(board) }.to raise_error("No legal moves available - game should have ended!")
    end
  end
end
