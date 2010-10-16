class Executor
  def initialize(board,carl,code)
    @board = Board.from_board(board)
    @carl = carl
    @code = code
  end

  def execute
    @code.each do |command|
      case command
      when 'move'
        transform = @carl.if_move
        current = @board.carl
        new = [current[0] + transform[0],current[1] + transform[1]]
        raise Explosion,"ran into a wall" if @board.wall?(*new)
        @board.place_carl(*new)
      when 'turnleft'
        @carl.turnleft
      when 'putbeacon'
        @carl.putdown_beacon
        @board.add_beacon(*@board.carl)
      when 'pickbeacon'
        raise Explosion,"no beacon at #{@board.carl.inspect}" unless @board.beacon?(*@board.carl)
        @board.remove_beacon(*@board.carl)
        @carl.pickup_beacon
      else
        raise "unknown command"
      end
    end
    @board
  end
end

class Explosion < Exception; end
