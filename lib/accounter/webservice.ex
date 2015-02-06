defmodule Accounter.Webservice do
  use GenServer
  require Logger
  require HTTPoison


  @doc """
  Fetch a URL asynchronously and post results to an endpoint

    * `fetch_url` - The URL to fetch
    * `post_to_url` - The URL to POST results back to

  ## Examples

      iex> async_query("example.com", "myendpoint.com")
      :ok

  """
  def async_query(fetch_url, post_to_url) do
    ws_pid = :poolboy.checkout(:webservice_pool)
    Task.start fn ->
      :ok = GenServer.call(ws_pid, {:query, fetch_url, post_to_url})
      :poolboy.checkin(ws_pid)
    end
  end

  def start_link() do
    Logger.info "Starting webservice."
    GenServer.start_link(__MODULE__, [])
  end

  def init(_) do
    Logger.info "Init de Webservice"
    {:ok, nil}
  end

  def handle_call({:query, fetch_url, post_to_url}, from, state) do
    Logger.info "handling call"
    {:ok, response} = HTTPoison.get "http://httpbin.org/user-agent"
    # TODO need to handle bad response
    Logger.info response.body
    HTTPoison.post "http://0.0.0.0:4000/", ""
    {:reply, :ok, state}
  end

  def handle_call(msg, _from, state) do
    Logger.info "Handling whatever"
    {:noreply, state}
  end
end
