class Executor

  attr_reader :carl
  attr_reader :board
  attr_reader :last_index

  def initialize(board,carl,code)
    @board = Board.from_board(board) unless board.nil?
    @carl = carl
    @code = code || []
  end

  def execute!
    return nil if @board.nil?
    @last_index = 0
    @code.each do |command|
      next if command.strip =~ /^$/
      case command
      when 'move'
        transform = @carl.if_move
        current = @board.carl
        new = [current[0] + transform[0],current[1] + transform[1]]
        raise Explosion.new("ran into a wall at #{new[0]},#{new[1]}",new) if @board.wall?(*new)
        @board.place_carl(*new)
      when 'turnleft'
        @carl.turnleft
      when 'putbeacon'
        begin
        @carl.putdown_beacon
        rescue Explosion => exception
          raise Explosion.new(exception.message,@board.carl)
        end
        @board.add_beacon(*@board.carl)
      when 'pickbeacon'
        raise Explosion.new("no beacon at #{@board.carl.inspect}",@board.carl) unless @board.beacon?(*@board.carl)
        @board.remove_beacon(*@board.carl)
        @carl.pickup_beacon
      else
        raise "unknown command '#{command}'"
      end
      @last_index += 1
    end
    @board
  end
end

class Explosion < Exception
  def initialize(msg,where)
    super(msg)
    unless where.nil?
      @where = where
      @where[0] = 0 if @where[0] < 0 
      @where[1] = 0 if @where[1] < 0 
      @where[0] = 7 if @where[0] > 7
      @where[1] = 7 if @where[1] > 7
    end
  end

  def where?; @where; end
end
