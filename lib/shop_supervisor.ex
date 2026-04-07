defmodule ShopSupervisor do
  use Supervisor

  def start_link do
    IO.inspect("Starting ShopSupervisor...", label: "ShopSupervisor", pretty: true)
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_init_arg) do
    children = [
      CartSupervisor,
      VisitorTracker
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
