class AddBeatenToSolutions < ActiveRecord::Migration
  def self.up
    add_column :solutions, :beat, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :solutions, :beat
  end
end
