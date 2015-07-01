defmodule Dj54bApiPhoenix.SpotifyController do
  use Dj54bApiPhoenix.Web, :controller

  def info(conn, _params) do
    json conn, %{foo: "bar"}
  end
end
