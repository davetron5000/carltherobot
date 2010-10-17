class Move; def self.command_name; 'move'; end; end
class Turnleft; def self.command_name; 'turnleft'; end; end
class PutBeacon; def self.command_name; 'putbeacon'; end; end
class PickBeacon; def self.command_name; 'pickbeacon'; end; end

class Branch
  attr_reader :condition
  attr_reader :code

  def self.command_name; 'branch'; end

  def initialize(condition,code)
    @condition = condition
    @code = code
  end
end

class Loop < Branch
  def self.command_name; 'loop'; end
end

class Iterate < Branch
  def initialize(count,code)
    super(count.to_i,code)
  end
  def self.command_name; 'iterate'; end
end
class Command < ActiveRecord::Base
  def self.available_to(player)
    commands = Command.arel_table
    Command.where(commands[:unlock].lteq(player.unlock))
  end

  def self.command_named(command_name)
    commands = Command.arel_table
    Command.where(commands[:command_name].eq(command_name)).first
  end

  # Returns true if this command is available to the give Player
  def available?(player)
    self.unlock <= player.unlock
  end

  KNOWN_COMMANDS = [ Move, Turnleft, PutBeacon, PickBeacon, Branch, Loop, Iterate ];
  CONTROL_COMMANDS = [Branch,Loop,Iterate];
end
