defmodule Blog.Config do
  @moduledoc "API for fetching configuration"

  # coveralls-ignore-start
  @spec repo! :: String.t()
  def repo!, do: System.fetch_env!("GITHUB_REPO_NAME")

  @spec access_token! :: String.t()
  def access_token!, do: System.fetch_env!("GITHUB_REPO_ACCESS_TOKEN")
end
