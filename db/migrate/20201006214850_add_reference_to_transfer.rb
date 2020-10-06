class AddReferenceToTransfer < ActiveRecord::Migration[6.0]
  def change
    add_reference :transfers, :origin
    add_reference :transfers, :destiny
  end
end
