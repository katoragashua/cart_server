defmodule ProductsServer do
  use GenServer

  # Client API
  def start_link(_initial_arg) do
    IO.inspect("Starting ProductsServer...", label: "ProductsServer", pretty: true)
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  # def add_product(product = %Product{}) do
  #   GenServer.cast(__MODULE__, {:add_product, product})
  # end

  def add_product(attrs) when is_map(attrs) do
    GenServer.cast(__MODULE__, {:add_product, attrs})
  end

  # Server Callbacks
  @impl true
  def init(state) do
    # trap_exit(). Trapping exits is used when you want your process to treat exit signals as messages. This is useful when you want to monitor other processes and react to their termination, or when you want to ensure that your process can perform cleanup tasks before it terminates.
    # This however, doesn't work for :kill terms. :kill terms are untrappable.
    Process.flag(:trap_exit, true)
    {:ok, state}
  end

  # handle_call clauses
  @impl true
  def handle_call(:get_products, _from, state) do
    {:reply, Map.values(state), state}
  end

  @impl true
  def handle_call({:get_product, id}, _from, state) do
    product = Map.get(state, id)
    {:reply, product, state}
  end

  # handle_cast clauses
  # @impl true
  # def handle_cast({:add_product, product}, state) do
  #   new_state = %{state | products: [product | state.products]}
  #   {:noreply, new_state}
  # end

  @impl true
  def handle_cast({:add_product, attrs}, state) do # This is a bit more complex than the previous one, we need to generate a product from the attrs and then add it to the state. attrs is a map that contains the product attributes, we need to generate a product from it and then add it to the state. The state is a map that contains the products, we can use the product id as the key and the product struct as the value.
    product_id = DateTime.utc_now() |> DateTime.to_unix(:microsecond) |> Integer.to_string()

    product = generate_product_from_attrs(attrs)
    new_state = Map.put(state, product_id, product)
    {:noreply, new_state}
  end

  # handle_info clauses
  # handle_info is a callback that is used to handle messages that are sent to the process. This is useful when you want to handle messages that are not part of the GenServer API, such as exit signals or custom messages.
  @impl true
  def handle_info({:EXIT, from, reason}, state) do
    IO.inspect({from, reason}, label: "ProductsServer EXIT", pretty: true)
    {:noreply, state}
  end

  @impl true
  # But this is very generic, we can create a handle_info callback that looks out specifically of :EXIT messages as seen above
  def handle_info(msg, state) do
    IO.inspect(msg, label: "ProductsServer Info", pretty: true)
    {:noreply, state}
  end

  defp generate_product_from_attrs(attrs) do
    Product.generate_product(attrs)
  end
end
