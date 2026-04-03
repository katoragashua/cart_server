defmodule CountServer do
  use GenServer

  # Client API
  def start_link(_initial_arg) do
    IO.puts("Starting CountServer...")
    GenServer.start_link(__MODULE__, %{count: 0}, name: :count_server)
  end

  # Server Callbacks

  @impl true

  # init is a callback that is called when the GenServer is started. It receives the initial state as an argument and returns a tuple with the new state and an optional timeout. The timeout is used to specify how long the GenServer should wait before sending a :timeout message to itself. This can be useful for implementing periodic tasks or for handling timeouts in a more efficient way than using Process.send_after/3.
  def init(state) do
    {:ok, state}
    # {:ok, state, 5_000}
    # :ignore
  end

  @impl true
  def handle_call(:get_count, _from, state) do
    {:reply, state.count, state}
  end

  @impl true
  def handle_call(:increment, from, state) do
    :timer.sleep(10_000)
    IO.inspect(from, label: "CountServer increment from", pretty: true)
    new_state = %{state | count: state.count + 1}
    {:reply, :ok, new_state}
  end

  @impl true
  def handle_call(:decrement, _from, state) do
    new_state = %{state | count: state.count - 1}
    {:reply, :ok, new_state}
  end
end
