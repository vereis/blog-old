defmodule BlogWeb.AssetController do
  use BlogWeb, :controller

  def fetch(conn, params) do
    IO.inspect(params)
    conn
  end
end
