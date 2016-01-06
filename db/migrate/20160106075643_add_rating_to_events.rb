class AddRatingToEvents < ActiveRecord::Migration
  def up
    add_column :events, :rating, :integer
  end
  def down
    remove_column :events, :rating, :integer
  end
end
