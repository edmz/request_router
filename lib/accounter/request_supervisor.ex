defmodule Accounter.RequestSupervisor do
  use Supervisor
  require Logger

  @pool_size 50 # Max number of simult requests

  def start_link(opts \\ []) do
    Logger.info "Starting supervisor."
    Supervisor.start_link(__MODULE__, [opts])
  end

  def init(opts) do
    pool_opts = [
      name: {:local, :webservice_pool},
      worker_module: Accounter,Webservice,
      size: opts[:pool_size] || @pool_size,
      max_overflow: 0
    ]

    children = [
      :poolboy.child_spec(:webservice_pool, pool_opts, []),
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
