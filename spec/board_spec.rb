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
end
