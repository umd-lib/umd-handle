class AddPrefixSuffixIndexToHandles < ActiveRecord::Migration[6.1]
  def change
    add_index :handles, [:prefix, :suffix], unique: true
  end
end
