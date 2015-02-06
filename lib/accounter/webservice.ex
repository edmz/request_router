defmodule Accounter.Webservice do
  use GenServer
  require Logger
  require HTTPoison

  def init(_) do
    Logger.info "Init de Webservice"
    {:ok, nil}
  end

  def start_link() do
    Logger.info "Starting webservice."
    GenServer.start_link(__MODULE__, nil, name: :webservice)
  end  

  def handle_cast({:query, _}, _) do
    Logger.info "handling call"
    {:ok, response} = HTTPoison.get "http://httpbin.org/user-agent"
    Logger.info response.body
    HTTPoison.post "http://0.0.0.0:4000/", ""
    {:noreply, response.body}
  end

  def handle_cast(a, b) do
    Logger.info "Handling whatever"
  end

  def server_process() do
    Accounter.Webservice.start_link
    GenServer.cast(:webservice, {:query, "bleh"})
  end
end
