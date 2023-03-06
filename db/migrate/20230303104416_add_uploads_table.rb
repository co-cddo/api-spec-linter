class AddUploadsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :uploads, &:timestamps
  end
end
