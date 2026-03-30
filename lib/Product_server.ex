defmodule ProductServer do
  use GenServer

  def start_link(_arg) do
    IO.inspect("Starting ProductServer...", label: "ProductServer", pretty: true)
    GenServer.start_link(__MODULE__, %Product{}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    # trap_exit(). Trapping exits is used when you want your process to treat exit signals as messages. This is useful when you want to monitor other processes and react to their termination, or when you want to ensure that your process can perform cleanup tasks before it terminates.
    # This however, doesn't work for :kill terms. :kill terms are untrappable.
    Process.flag(:trap_exit, true)
    {:ok, state}
  end

  @impl true
  def handle_info({:EXIT, from, reason}, state) do
    IO.inspect({from, reason}, label: "ProductServer EXIT", pretty: true)
    {:noreply, state}
  end

  @impl true
  # But this is very generic, we can create a handle_info callback that looks out specifically of :EXIT messages as seen above
  def handle_info(msg, state) do
    IO.inspect(msg, label: "ProductServer Info", pretty: true)
    {:noreply, state}
  end



end
