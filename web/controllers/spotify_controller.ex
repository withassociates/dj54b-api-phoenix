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
    spotify_tell("set the sound volume to #{volume + 6}")
    info(conn, _params)
  end

  def down(conn, _params) do
    spotify_tell("set the sound volume to #{volume - 4}")
    info(conn, _params)
  end

  def info(conn, _params) do
    json(conn, spotify_info)
  end

  def options(conn, _params) do
    text(conn, "")
  end

  defp volume do
    spotify_tell("get sound volume") |> parse_volume
  end

  defp spotify_info do
    value = spotify_tell(~s["" & (get sound volume) & "|" & (get player state) & "|" & (get the spotify url of the current track) & "|" & (get the name of the current track) & "|" & (get the artist of the current track)])

    [volume, state, id, name, artist] = String.split(value, "|")

    %{
      volume: parse_volume(volume),
      state: state,
      track: %{
        id: id,
        name: name,
        artist: artist
      }
    }
  end

  defp spotify_tell(instruction) do
    {value,_} = cmd("osascript", ["-e", ~s[tell application "Spotify" to #{instruction}]])
    String.strip(value)
  end

  defp parse_volume(str) do
    {result,_} = Integer.parse(str)
    result
  end
end
