defmodule Dj54bApiPhoenix.Router do
  use Dj54bApiPhoenix.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Dj54bApiPhoenix do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/info", SpotifyController, :info
  end

  # Other scopes may use custom stacks.
  # scope "/api", Dj54bApiPhoenix do
  #   pipe_through :api
  # end
end
