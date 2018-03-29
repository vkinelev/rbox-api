class CreateSandboxes < ActiveRecord::Migration[5.1]
  def change
    create_table :sandboxes do |t|
      t.string :name

      t.timestamps
    end
  end
end
