Sequel.migration do
  up do
    create_table(:vlans) do
      foreign_key :id, :resources, :primary_key => true, :on_delete => :cascade
      foreign_key :openflow_switch_id, :openflow_switches, :on_delete => :cascade

      String :number
    end
  end

  down do
    drop_table(:vlans)
  end
end