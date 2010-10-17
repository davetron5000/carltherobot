class Command < ActiveRecord::Base
  def self.available_to(player)
    commands = Command.arel_table
    Command.where(commands[:unlock].lteq(player.unlock))
  end

  def self.named(command_name)
    commands = Command.arel_table
    Command.where(commands[:command_name].eq(command_name)).first
  end

  # Returns true if this command is available to the give Player
  def available?(player)
    self.unlock <= player.unlock
  end
end

class Branch
  attr_reader :condition
  attr_reader :code

  def initialize(condition,code)
    @condition = condition
    @code = code
  end
end

class Loop < Branch
end

class Iterate < Branch
end
