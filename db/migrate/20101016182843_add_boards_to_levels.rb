class AddBoardsToLevels < ActiveRecord::Migration
  def self.up
    add_column :levels, :board1, :text
    add_column :levels, :board2, :text
  end

  def self.down
    remove_column :levels, :board2
    remove_column :levels, :board1
  end
end
