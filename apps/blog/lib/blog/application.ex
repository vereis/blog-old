defmodule Blog.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  # coveralls-ignore-start
  @moduledoc false

  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      Blog.Repo,
      {Finch, name: Blog.Finch},
      {Phoenix.PubSub, name: Blog.PubSub},
      {Oban, Application.fetch_env!(:blog, Oban)}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Blog.Supervisor)
  end

  # coveralls-ignore-stop
end
