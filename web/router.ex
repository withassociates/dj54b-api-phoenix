defmodule Dj54bApiPhoenix.Router do
  use Dj54bApiPhoenix.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :cors
  end

  scope "/", Dj54bApiPhoenix do
    pipe_through :api

    get "/play", SpotifyController, :play
    get "/pause", SpotifyController, :pause
    get "/next", SpotifyController, :next
    get "/up", SpotifyController, :up
    get "/down", SpotifyController, :down
    get "/info", SpotifyController, :info
    get "/peace", SpotifyController, :peace
    options "*path", SpotifyController, :options
  end

  def cors(conn, _params) do
    conn
    |> put_resp_header("access-control-allow-origin", "*")
    |> put_resp_header("access-control-allow-methods", "GET, PUT, HEAD, OPTIONS")
  end
end
