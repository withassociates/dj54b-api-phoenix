defmodule Dj54bApiPhoenix.SpotifyController do
  import System, only: [cmd: 2]
  use Dj54bApiPhoenix.Web, :controller

  def info(conn, _params) do
    json conn, %{
      volume: volume,
      state: state,
      track: track
    }
  end

  def volume do
    spotify_get("sound volume")
  end

  def state do
    spotify_get("player state")
  end

  def track do
    %{
      id: track_id,
      name: track_name,
      artist: track_artist
    }
  end

  def track_id do
    spotify_get("the current track's spotify url")
  end

  defp track_name do
    spotify_get("the current track's name")
  end

  defp track_artist do
    spotify_get("the current track's artist")
  end

  defp spotify_get(attr) do
    {value,_} = cmd("osascript", ["-e", "tell application \"Spotify\" to get #{attr}"])
    String.strip(value)
  end
end
