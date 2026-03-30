defmodule Product do
  defstruct [:id, :name, :price, :description, :quantity, :reorder_level, reorder_quantity: 0]
end
