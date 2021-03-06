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
    @last_index = -1 
    execute_internal!(@code)
  end

  def execute_internal!(code,depth=0)
    raise Explosion.new("Stack Overflow",nil) if depth > 20
    code.each do |command|
      next if command.nil? || (command.respond_to?(:strip) && command.strip =~ /^$/)
      case command
      when 'move'
        transform = @carl.if_move
        current = @board.carl
        raise "No carl on the board?!?!??!" if current.nil?
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
      when Iterate
        condition = command.condition
        code_block = command.code
        count = 1
        condition.times do 
          begin
            execute_internal!(code_block,depth+1)
            count += 1
          rescue Explosion => ex
            raise Explosion.new(ex.message + "(on iterateion #{count})",ex.where?)
          end
          (condition-2).times { @last_index -= code_block.size }
          @last_index += 1 # extra for the 'end'
        end
      when Loop
        count = 0
        condition = command.condition
        code_block = command.code
        while (Conditions.send(condition,@board.carl,@carl.direction,@board))
          raise Explosion.new("Possible Infinite Loop",nil) if count > 50
          execute_internal!(code_block,depth+1)
          count += 1
        end
        (count-1).times { @last_index -= code_block.size }
          @last_index += 1 # extra for the 'end'
      when Branch
        condition = command.condition
        code_block = command.code
        if (Conditions.send(condition,@board.carl,@carl.direction,@board))
          execute_internal!(code_block,depth+1)
        else
          @last_index += code_block.size # have to account for it
        end
        @last_index += 1 # extra for the 'end'
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
