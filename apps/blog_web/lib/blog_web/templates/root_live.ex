defmodule BlogWeb.RootLive do
  @moduledoc """
  Root layout which gets rendered as a liveview and sets up sidebar / blog content
  views.
  """

  use BlogWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <h1>
      Hello, world!
    </h1>
    """
  end
end
