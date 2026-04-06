defmodule Product do
  defstruct [:id, :name, :price, :description, :quantity, :reorder_level, reorder_quantity: 0]

  def generate_product(attrs) do
    # %Product{
    #   id: generate_product_id(),
    #   name: Map.get(attrs, :name, "Unnamed Product"),
    #   price: Map.get(attrs, :price, 0.0),
    #   description: Map.get(attrs, :description, ""),
    #   quantity: Map.get(attrs, :quantity, 0),
    #   reorder_level: Map.get(attrs, :reorder_level, 0),
    #   reorder_quantity: Map.get(attrs, :reorder_quantity, 0)
    # }
    %Product{
      id: generate_product_id(),
      name: attrs[:name] || "Unnamed Product",
      price: attrs[:price] || 0.0,
      description: attrs[:description] || "",
      quantity: attrs[:quantity] || 0,
      reorder_level: attrs[:reorder_level] || 0,
      reorder_quantity: attrs[:reorder_quantity] || 0
    }
    |> validate_product()
  end

  defp generate_product_id do
    :crypto.strong_rand_bytes(8) |> Base.encode16(case: :lower)
  end

  defp validate_product(%Product{} = product) do
    cond do
      product.price < 0 ->
        {:error, "Price cannot be negative"}

      product.quantity < 0 ->
        {:error, "Quantity cannot be negative"}

      true ->
        {:ok, product}
    end
  end
end
