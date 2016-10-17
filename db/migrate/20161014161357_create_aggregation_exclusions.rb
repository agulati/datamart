class CreateAggregationExclusions < ActiveRecord::Migration[5.0]
  def change
    create_table :aggregation_exclusions do |t|
      t.integer :exclusion_id
      t.string  :exclusion_type
      t.timestamps
    end
  end
end
