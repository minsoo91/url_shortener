class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
    	t.integer :submitter_id
    	t.integer :shortened_url_id

    	t.timestamps
    end
  end
end
