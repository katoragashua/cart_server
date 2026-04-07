defmodule VisitorTracker do
  use Agent

  def start_link(_initial_arg) do
    IO.inspect("Starting VisitorTracker...", label: "VisitorTracker", pretty: true)
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def track_visit_add(visitor_id) when is_binary(visitor_id) do
    Agent.update(__MODULE__, fn count -> Map.update(count, visitor_id, 1, &(&1 + 1)) end)
  end

  def track_visit_subtract(visitor_id) when is_binary(visitor_id) do
    Agent.update(__MODULE__, fn count -> Map.update(count, visitor_id, 0, &max(&1 - 1, 0)) end)
  end

  def get_visit_count(visitor_id) when is_binary(visitor_id) do
    Agent.get(__MODULE__, fn count -> Map.get(count, visitor_id, 0) end)
  end
end

# defmodule VisitorTracker do
#   use GenServer

#   # Client API
#   def start_link(_initial_arg) do
#     IO.inspect("Starting VisitorTracker...", label: "VisitorTracker", pretty: true)
#     GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
#   end

#   def track_visit(visitor_id) when is_binary(visitor_id) do
#     GenServer.cast(__MODULE__, {:track_visit, visitor_id})
#   end

#   def get_visits do
#     GenServer.call(__MODULE__, :get_visits)
#   end

#   # Server Callbacks
#   @impl true
#   def init(state) do
#     Process.flag(:trap_exit, true)
#     {:ok, state}
#   end

#   @impl true
#   def handle_call(:get_visits, _from, state) do
#     {:reply, Map.values(state), state}
#   end

#   @impl true
#   def handle_cast({:track_visit, visitor_id}, state) do
#     new_state = Map.update(state, visitor_id, 1, &(&1 + 1))
#     {:noreply, new_state}
#   end
# end
