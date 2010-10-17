require 'carl'
class Conditions
  def self.front_clear(current_location,current_direction,board)
    transform = CarlTheRobot.direction_transform(current_direction)
    new_location = [current_location[0] + transform[0],current_location[1] + transform[1]]
    !board.wall?(*new_location)
  end

  def self.not_front_clear(current_location,current_direction,board)
    !front_clear(current_location,current_direction,board)
  end

  def self.on_beacon(current_location,current_direction,board)
    board.beacon? *current_location
  end

  def self.not_on_beacon(current_location,current_direction,board)
    !on_beacon(current_location,current_direction,board)
  end
end
