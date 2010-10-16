class CreateLevels < ActiveRecord::Migration
  def self.up
    create_table :levels do |t|
      t.string :goal_description
      t.integer :ordinal
      t.string :difficulty

      t.timestamps
    end
    add_column(:solutions,:level_id, :integer)
  end

  def self.down
    drop_table :levels
    remove_column(:solutions,:level_id)
  end
end
