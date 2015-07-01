defmodule Dj54bApiPhoenix.PageControllerTest do
  use Dj54bApiPhoenix.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
