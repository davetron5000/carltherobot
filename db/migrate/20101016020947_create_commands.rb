class CreateCommands < ActiveRecord::Migration
  def self.up
    create_table :commands do |t|
      t.string :name
      t.string :command_name
      t.integer :unlock
      t.string :description

      t.timestamps
    end
    add_column(:players,:unlock,:integer,:null => false,:default => 1)
    Command.create(:name => 'Move',
                   :command_name => 'move',
                   :unlock => 1,
                   :description => "Move Carl one step in the direction he's facing")
    Command.create(:name => 'Turn Left',
                   :command_name => 'turnleft',
                   :unlock => 2,
                   :description => "Rotate Carl in place to the left")
    Command.create(:name => 'Pick Beacon',
                   :command_name => 'pickbeacon',
                   :unlock => 3,
                   :description => "Pick up the beacon where Carl is standing")
    Command.create(:name => 'Put Beacon',
                   :command_name => 'putbeacon',
                   :unlock => 4,
                   :description => "Put down a beacon where Carl is standing")
    Command.create(:name => 'Branch',
                   :command_name => 'branch',
                   :unlock => 5,
                   :description => "Do somethingn conditionally")
    Command.create(:name => 'Loop While',
                   :command_name => 'loop',
                   :unlock => 6,
                   :description => "Keep doing something until a condition holds true")
    Command.create(:name => 'Iterate',
                   :command_name => 'iterate',
                   :unlock => 7,
                   :description => "Do something a fixed number of times")
  end

  def self.down
    drop_table :commands
    remove_column(:players,:unlock)
  end
end
