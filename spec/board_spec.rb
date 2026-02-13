require_relative "../lib/chess"

describe Chess::Board do
  subject(:board) { described_class.new }

  describe "#initialize" do
    it "creates an 8x8 board" do
      expect(board.state.length).to eq(8)
      expect(board.state[0].length).to eq(8)
    end

    it "sets up white pieces on rows 6-7" do
      expect(board.state[6][0]).to be_a(Chess::Pawn)
      expect(board.state[6][0].color).to eq(:white)
      expect(board.state[7][0]).to be_a(Chess::Rook)
      expect(board.state[7][0].color).to eq(:white)
    end

    it "sets up black pieces on rows 0-1" do
      expect(board.state[0][0]).to be_a(Chess::Rook)
      expect(board.state[0][0].color).to eq(:black)
      expect(board.state[1][0]).to be_a(Chess::Pawn)
      expect(board.state[1][0].color).to eq(:black)
    end
  end

  describe "#to_s" do
    it "returns a string representation of the board" do
      expect(board.to_s).to include("♔")
      expect(board.to_s).to include("♚")
      expect(board.to_s).to include("·")
    end

    it "has row and column labels" do
      expect(board.to_s).to match(/0 1 2 3 4 5 6 7/)
      expect(board.to_s).to match(/^0 /)
    end
  end

  describe "#empty?" do
    it "returns true for empty squares" do
      expect(board.empty?([4, 4])).to be true
    end

    it "returns false for occupied squares" do
      expect(board.empty?([0, 0])).to be false
      expect(board.empty?([7, 0])).to be false
    end
  end

  describe "#same_color?" do
    it "returns true when both squares have pieces of the same color" do
      expect(board.same_color?([0, 0], [0, 2])).to be true
    end

    it "returns false when squares have different color pieces" do
      expect(board.same_color?([0, 0], [7, 0])).to be false
    end

    it "returns false when destination is empty" do
      expect(board.same_color?([0, 0], [4, 4])).to be false
    end
  end

  describe "#move_piece" do
    it "moves a piece from one position to another" do
      board.move_piece([6, 0], [4, 0])
      expect(board.state[4][0]).to be_a(Chess::Pawn)
      expect(board.state[6][0]).to be_nil
    end

    it "allows capturing opponent pieces" do
      board.move_piece([6, 0], [5, 0])
      board.move_piece([1, 0], [3, 0])
      board.move_piece([5, 0], [4, 0])
      board.move_piece([3, 0], [4, 0])
      expect(board.state[4][0].color).to eq(:black)
    end
  end
end
