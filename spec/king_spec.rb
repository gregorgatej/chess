require_relative "../lib/chess"

describe Chess::King do

  describe "#valid_move?" do
    let(:board) { Chess::Board.new }
    subject(:king) { described_class.new(:white) }

    it "allows move 1 square in any direction" do
      board.state[4][4] = king
      expect(king.valid_move?([4, 4], [5, 5], board)).to be true
      expect(king.valid_move?([4, 4], [4, 5], board)).to be true
      expect(king.valid_move?([4, 4], [5, 3], board)).to be true
    end

    it "prevents move more than 1 square" do
      king = Chess::King.new(:white)
      board.state[3][3] = king
      expect(king.valid_move?([3, 3], [5, 5], board)).to be false
    end

    it "prevents capturing own piece" do
      expect(king.valid_move?([7, 4], [6, 4], board)).to be false
    end
  end

  describe "#in_check?" do
    subject(:white_king) { described_class.new(:white) }
    let(:board) { Chess::Board.new }
    let(:black_rook) { Chess::Rook.new(:black) }
    let(:black_queen) { Chess::Queen.new(:black) }

    before do
      board.state = Array.new(8) { Array.new(8, nil) }
    end

    it "returns true when king is under attack by opponent piece" do
      board.state[4][4] = white_king
      board.state[4][6] = black_rook

      expect(white_king.in_check?([4, 4], board)).to be true
    end

    it "returns false when king is not under attack" do
      board.state[4][4] = white_king
      board.state[2][2] = black_rook
      
      expect(white_king.in_check?([4, 4], board)).to be false
    end

    it "returns true when attacked by multiple pieces" do
      board.state[4][4] = white_king
      board.state[4][6] = black_rook
      board.state[3][3] = black_queen
      
      expect(white_king.in_check?([4, 4], board)).to be true
    end
  end

  describe "#in_checkmate?" do
    let(:white_king) { described_class.new(:white) }
    let(:board) { Chess::Board.new }
    let(:black_rook1) { Chess::Rook.new(:black) }
    let(:black_rook2) { Chess::Rook.new(:black) }

    before do
      board.state = Array.new(8) { Array.new(8, nil) }
    end

    it "returns true when king is in checkmate" do
      board.state[4][4] = white_king
      board.state[4][6] = black_rook1
      board.state[6][4] = black_rook2
      
      expect(white_king.in_checkmate?([4, 4], board)).to be true
    end

    it "returns false when king is in check but can escape" do
      board.state[4][4] = white_king
      board.state[4][6] = black_rook1
      
      expect(white_king.in_checkmate?([4, 4], board)).to be false
    end

    it "returns false when king is not in check" do
      board.state[4][4] = white_king
      board.state[2][2] = black_rook1
      
      expect(white_king.in_checkmate?([4, 4], board)).to be false
    end
  end
end
