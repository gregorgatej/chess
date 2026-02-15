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

  describe "#valid_move?" do
  let(:current_player) { Chess::Player.new(:white) }

    it "returns false for moves outside board bounds" do
      expect(board.valid_move?([-1, 0], [0, 0], current_player)).to be false
      expect(board.valid_move?([0, 0], [8, 0], current_player)).to be false
    end

    it "returns false for same position" do
      expect(board.valid_move?([0, 0], [0, 0], current_player)).to be false
    end

    it "returns false for empty square" do
      expect(board.valid_move?([4, 4], [5, 5], current_player)).to be false
    end

    it "returns false for capturing own piece" do
      expect(board.valid_move?([0, 0], [0, 1], current_player)).to be false
    end

    it "returns false when moving opponent's figure" do
      expect(board.valid_move?([0, 1], [0, 2], current_player)).to be false
    end
  end

  describe "#find_king" do
  it "finds the white king on the board" do
    king_pos = board.find_king(:white)
    expect(king_pos).to eq([7, 4])
    expect(board.state[7][4]).to be_a(Chess::King)
    expect(board.state[7][4].color).to eq(:white)
  end

  it "finds the black king on the board" do
    king_pos = board.find_king(:black)
    expect(king_pos).to eq([0, 4])
    expect(board.state[0][4]).to be_a(Chess::King)
    expect(board.state[0][4].color).to eq(:black)
  end

  it "finds the king after it has been moved" do
    white_king = board.state[7][4]
    board.state[4][4] = white_king
    board.state[7][4] = nil

    king_pos = board.find_king(:white)
    expect(king_pos).to eq([4, 4])
  end

  it "returns nil if no king is found" do
    # Remove all kings
    board.state[7][4] = nil
    board.state[0][4] = nil

    white_king_pos = board.find_king(:white)
    black_king_pos = board.find_king(:black)
    expect(white_king_pos).to be_nil
    expect(black_king_pos).to be_nil
  end
end

  describe "#move_leaves_king_in_check?" do
    let(:white_king) { Chess::King.new(:white) }
    let(:black_rook) { Chess::Rook.new(:black) }
    let(:white_player) { Chess::Player.new(:white) }

    it "returns true when king remains in check after move" do
      board.state[4][4] = white_king
      board.state[4][1] = black_rook

      expect(board.move_leaves_king_in_check?([4, 4], [4, 3], white_player)).to be true
    end

    it "returns false when king doesn't remain in check after move" do
      board.state[4][4] = white_king
      board.state[4][1] = black_rook

      expect(board.move_leaves_king_in_check?([4, 4], [3, 4], white_player)).to be false
    end
  end
end
