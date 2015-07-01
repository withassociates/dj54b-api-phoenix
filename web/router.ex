defmodule Dj54bApiPhoenix.Router do
  use Dj54bApiPhoenix.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Dj54bApiPhoenix do
    pipe_through :api

    get "/play", SpotifyController, :play
    get "/pause", SpotifyController, :pause
    get "/next", SpotifyController, :next
    get "/up", SpotifyController, :up
    get "/down", SpotifyController, :down
    get "/info", SpotifyController, :info
  end
end
