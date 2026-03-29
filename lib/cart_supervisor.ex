defmodule CartSupervisor do
  use Supervisor

  def start_link(_arg) do
    IO.inspect("Starting CartSupervisor...", label: "CartSupervisor", pretty: true)
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_init_arg) do
    children = [
      # cartserver: {CartServer, []}
      CartServer
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
