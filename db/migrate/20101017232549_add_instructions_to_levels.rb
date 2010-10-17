class AddInstructionsToLevels < ActiveRecord::Migration
  def self.up
    add_column :levels, :instructions, :string
  end

  def self.down
    remove_column :levels, :instructions
  end
end
