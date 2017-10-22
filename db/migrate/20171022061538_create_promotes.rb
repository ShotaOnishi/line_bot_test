class CreatePromotes < ActiveRecord::Migration[5.0]
  def change
    create_table :promotes do |t|

      t.timestamps
    end
  end
end
