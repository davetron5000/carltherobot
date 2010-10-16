class Command < ActiveRecord::Base
  def self.available_to(player)
    commands = Command.arel_table
    Command.where(commands[:unlock].lteq(player.unlock))
  end

  # Returns true if this command is available to the give Player
  def available?(player)
    self.unlock <= player.unlock
  end
end
