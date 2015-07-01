defmodule Dj54bApiPhoenix.PageController do
  use Dj54bApiPhoenix.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
