class CreateCommands < ActiveRecord::Migration
  def self.up
    create_table :commands do |t|
      t.string :from
      t.text :input
      t.text :output
      t.timestamps
    end
  end

  def self.down
    drop_table :commands
  end
end
