defmodule AmritaWeb.PageController do
  use AmritaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
