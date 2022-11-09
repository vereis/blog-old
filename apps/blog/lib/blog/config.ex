defmodule Blog.Config do
  @moduledoc "API for fetching configuration"

  def repo!, do: System.fetch_env!("GITHUB_REPO_NAME")
  def access_token!, do: System.fetch_env!("GITHUB_REPO_ACCESS_TOKEN")
end
