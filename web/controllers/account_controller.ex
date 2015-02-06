defmodule Accounter.AccountController do
  use Phoenix.Controller

  plug :action

  def post(conn, _params) do
    Accounter.Webservice.server_process
    render conn, "index.html"
  end  
end
