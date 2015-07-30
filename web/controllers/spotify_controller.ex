defmodule Dj54bApiPhoenix.SpotifyController do
  import System, only: [cmd: 2]
  use Dj54bApiPhoenix.Web, :controller

  plug :check_peace

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

  def peace(conn, _params) do
    File.touch(peacefile_path())
    spotify_tell("pause")
    text(conn, "")
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

  defp check_peace(conn, _params) do
    peace_touched = peacefile_mtime()

    if peace_touched == nil do
      # No peacefile, continue
      return conn
    end

    peace_elapsed = seconds_since(peace_touched)
    peace_max = 60 * 60

    if peace_elapsed > peace_max do
      # Peacefile older than 60 minutes, continue
      return conn
    end

    # Peacefile was touched less than 60 minutes ago, halt the request

    peace_remaining = peace_max - peace_elapsed

    conn
    |> halt
    |> put_status(418)
    |> text("#{peace_remaining} seconds of peace remaining")
  end

  defp peacefile_mtime do
    {status,stat} = File.stat(peacefile_path())

    if status == :ok do
      stat.mtime
    end
  end

  defp seconds_since(then) do
    then_in_seconds = then |> :calendar.datetime_to_gregorian_seconds
    now_in_seconds = :calendar.local_time() |> :calendar.datetime_to_gregorian_seconds

    now_in_seconds - then_in_seconds
  end

  defp peacefile_path do
    Path.join([System.tmp_dir, "DJ54B_PEACE"])
  end
end
