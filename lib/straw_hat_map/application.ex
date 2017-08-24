defmodule StrawHat.Map.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(StrawHat.Map.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: StrawHat.Map.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
