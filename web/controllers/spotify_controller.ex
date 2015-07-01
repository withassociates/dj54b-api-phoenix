defmodule Dj54bApiPhoenix.SpotifyController do
  import System, only: [cmd: 2]
  use Dj54bApiPhoenix.Web, :controller

  def play(conn, _params) do
    spotify_tell("play")
    info(conn, _params)
  end

  def pause(conn, _params) do
    spotify_tell("pause")
    info(conn, _params)
  end

  def next(conn, _params) do
    spotify_tell("next track")
    info(conn, _params)
  end

  def up(conn, _params) do
    spotify_set("sound volume", volume + 6)
    info(conn, _params)
  end

  def down(conn, _params) do
    spotify_set("sound volume", volume - 4)
    info(conn, _params)
  end

  def info(conn, _params) do
    json conn, %{
      volume: volume,
      state: state,
      track: track
    }
  end

  defp volume do
    {result,_} = spotify_get("sound volume") |> Integer.parse
    result
  end

  defp state do
    spotify_get("player state")
  end

  defp track do
    %{
      id: track_id,
      name: track_name,
      artist: track_artist
    }
  end

  defp track_id do
    spotify_get("the current track's spotify url")
  end

  defp track_name do
    spotify_get("the current track's name")
  end

  defp track_artist do
    spotify_get("the current track's artist")
  end

  defp spotify_get(attr) do
    spotify_tell("get #{attr}")
  end

  defp spotify_set(attr, value) do
    spotify_tell("set the #{attr} to #{value}")
  end

  defp spotify_tell(instruction) do
    {value,_} = cmd("osascript", ["-e", "tell application \"Spotify\" to #{instruction}"])
    String.strip(value)
  end
end
