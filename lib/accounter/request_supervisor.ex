defmodule Accounter.RequestSupervisor do
  use Supervisor
  require Logger

  def start_link do
    Logger.info "Starting supervisor."
    Supervisor.start_link(__MODULE__, [])
  end  

  def init(_) do
    children = [
      worker(Accounter.Webservice, [], restart: :transient)
    ]
    supervise(children, strategy: :simple_one_for_one)    
  end
end
