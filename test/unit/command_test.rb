require 'test_helper'

class CommandTest < ActiveSupport::TestCase
  test "get available commands for new player" do
    new_player = players(:new_player)
    commands = Command.available_to(new_player)
    assert_equal 1,commands.size
    assert_equal 'move',commands[0].command_name
  end

  test "get available commands for advanced player" do
    advanced_player = players(:advanced_player)
    commands = Command.available_to(advanced_player)
    assert_equal 4,commands.size
    command_names = commands.map(&:command_name)
    assert command_names.include? 'move'
    assert command_names.include? 'turnleft'
    assert command_names.include? 'pickbeacon'
    assert command_names.include? 'putbeacon'
  end

  test "attempt to use commands not unlocked fails" do
    player = players(:advanced_player)
    Command.all.each do |command|
      if command.unlock <= player.unlock
        assert command.available?(player),"#{command.command_name} should be available"
      else
        assert !command.available?(player), "#{command.command_name} should NOT be available"
      end
    end
  end
end
