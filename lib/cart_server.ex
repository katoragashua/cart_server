defmodule CartServer do
  # Client API
  use GenServer

  def start_link(name) do
    IO.inspect("Starting CartServer...", label: "CartServer", pretty: true)
    GenServer.start_link(__MODULE__, %{cart: [], timer_ref: nil}, name: name)
  end

  def start_child(name) when is_atom(name) do
    IO.inspect("Starting CartServer #{name} child...", label: "CartServer", pretty: true)
    DynamicSupervisor.start_child(:dynamic_cart_supervisor, {__MODULE__, name})
  end

  def total(cart_id) when is_atom(cart_id), do: GenServer.call(cart_id, :total)

  def add_item(cart_id, item) when is_atom(cart_id),
    do: GenServer.cast(cart_id, {:add_item, item})

  def get_cart(cart_id) when is_atom(cart_id), do: GenServer.call(cart_id, :get_cart)
  # Server callbacks

  @impl true
  def init(state) do
    {:ok, state}
  end

  # We can also implement a child_spec manually to overide the default one provided by GenServer. This is useful when we want to customize the child specification, for example, to set a different restart strategy or to add additional options.
  def child_spec(arg) do
    IO.inspect(arg)

    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [arg]},
      restart: :permanent,
      shutdown: 5000,
      type: :worker
    }
  end

  # handle_cast clauses

  @impl true
  def handle_cast({:add_item, item}, state) do
    new_state =
      %{state | cart: [item | state.cart]}
      |> reminder_timer()

    {:noreply, new_state}
  end

  # handle_call clauses

  @impl true
  def handle_call(:total, _from, state) do
    # total = state.cart
    # |> Enum.reduce(0, fn item, acc -> acc + item.price  * item.quantity end)
    # {:reply, total, state}

    total =
      state.cart
      |> Enum.map(fn item -> item.price * item.quantity end)
      |> Enum.sum()

    {:reply, total, state}
  end

  def handle_call(:get_cart, _from, state) do
    {:reply, state.cart, state}
  end

  # handle_info clauses
  @impl true
  def handle_info(:reminder, state) do
    IO.puts("Don't forget to check out your cart!")
    {:noreply, state}
  end

  defp reminder_timer(state) do
    cond do
      state.timer_ref == nil ->
        new_state = %{state | timer_ref: Process.send_after(self(), :reminder, 10_000)}
        new_state

      true ->
        Process.cancel_timer(state.timer_ref)
        new_state = %{state | timer_ref: Process.send_after(self(), :reminder, 10_000)}
        new_state
    end
  end
end

# defmodule CartServer do
#   # Client API
#   use GenServer

#   def start_link(_arg) do
#     IO.inspect("Starting CartServer...", label: "CartServer", pretty: true)
#     GenServer.start_link(__MODULE__, %{cart: [], timer_ref: nil}, name: __MODULE__)
#   end

#   # We can also implement a child_spec manually to overide the default one provided by GenServer. This is useful when we want to customize the child specification, for example, to set a different restart strategy or to add additional options.
#   def child_spec(_arg) do
#     %{
#       id: __MODULE__,
#       start: {__MODULE__, :start_link, [[]]},
#       restart: :permanent,
#       shutdown: 5000,
#       type: :worker
#     }
#   end

#   def total, do: GenServer.call(__MODULE__, :total)

#   def add_item(item), do: GenServer.cast(__MODULE__, {:add_item, item})

#   def get_cart, do: GenServer.call(__MODULE__, :get_cart)

#   # Server callbacks

#   @impl true
#   def init(state) do
#     {:ok, state}
#   end

#   # handle_cast clauses

#   @impl true
#   def handle_cast({:add_item, item}, state) do
#     new_state =
#       %{state | cart: [item | state.cart]}
#       |> reminder_timer()

#     {:noreply, new_state}
#   end

#   # handle_call clauses

#   @impl true
#   def handle_call(:total, _from, state) do
#     # total = state.cart
#     # |> Enum.reduce(0, fn item, acc -> acc + item.price  * item.quantity end)
#     # {:reply, total, state}

#     total =
#       state.cart
#       |> Enum.map(fn item -> item.price * item.quantity end)
#       |> Enum.sum()

#     {:reply, total, state}
#   end

#   def handle_call(:get_cart, _from, state) do
#     {:reply, state.cart, state}
#   end

#   # handle_info clauses
#   @impl true
#   def handle_info(:reminder, state) do
#     IO.puts("Don't forget to check out your cart!")
#     {:noreply, state}
#   end

#   defp reminder_timer(state) do
#     cond do
#       state.timer_ref == nil ->
#         new_state = %{state | timer_ref: Process.send_after(self(), :reminder, 10_000)}
#         new_state

#       true ->
#         Process.cancel_timer(state.timer_ref)
#         new_state = %{state | timer_ref: Process.send_after(self(), :reminder, 10_000)}
#         new_state
#     end
#   end
# end
