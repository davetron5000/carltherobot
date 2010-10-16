class AddBoardsToLevels < ActiveRecord::Migration
  def self.up
    add_column :levels, :board0, :text, :null => false
    add_column :levels, :board1, :text, :null => true
    add_column :levels, :goal, :text, :null => false
    add_column :levels, :name, :string, :null => false
    remove_column :levels, :goal_description
  end

  def self.down
    add_column :levels, :goal_description, :string
    remove_column :levels, :name
    remove_column :levels, :goal
    remove_column :levels, :board1
    remove_column :levels, :board0
  end
end
