# Represents carl, insomuch as what carl knows about himself
class CarlTheRobot 
  attr_reader :direction
  def initialize
    @direction = :north
    @num_beacons = 0
  end

  def pickup_beacon
    @num_beacons += 1
  end

  def putdown_beacon
    raise Explosion,"no beacons!" if @num_beacons < 1
    @num_beacons -= 1
  end

  DIRECTIONS = [:north, :west, :south, :east]

  def turnleft
    current = DIRECTIONS.index @direction
    current += 1
    if (current >= DIRECTIONS.size)
      current = 0
    end
    @direction = DIRECTIONS[current]
  end

  def if_move
    case @direction
    when :north
      [-1,0]
    when :south
      [1,0]
    when :east
      [0,1]
    when :west
      [0,-1]
    when :west
    end
  end
end
