class AddHypeTextToLevels < ActiveRecord::Migration
  def self.up
    add_column :levels, :hype_text, :string
  end

  def self.down
    remove_column :levels, :hype_text
  end
end
