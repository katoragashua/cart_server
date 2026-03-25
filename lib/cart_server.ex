defmodule CartServer do
  # Client API
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{cart: [], timer_ref: nil}, name: __MODULE__)
  end

  def total, do: GenServer.call(__MODULE__, :total)

  def add_item(item), do: GenServer.cast(__MODULE__, {:add_item, item})

  def get_cart, do: GenServer.call(__MODULE__, :get_cart)

  # Server callbacks

  @impl true
  def init(state) do
    {:ok, state}
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
