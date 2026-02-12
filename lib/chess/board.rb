module Chess
  class Board
    ROWS = 8
    COLS = 8

    attr_accessor :state

    def initialize
      @state = Array.new(ROWS) { Array.new(COLS, nil) }
    end
  end
end
