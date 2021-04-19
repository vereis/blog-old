defmodule Blog.Repo do
  use Ecto.Repo, otp_app: :blog, adapter: Etso.Adapter

  def reset do
    {:ok, modules} = :application.get_key(:blog, :modules)

    # Looking at Etso's source, it should be pretty easy to make a PR
    # to add `delete_all` support but this will do for now.
    modules
    |> Enum.filter(&({:__schema__, 1} in &1.__info__(:functions)))
    |> Enum.flat_map(&all(&1))
    |> Enum.each(&delete/1)

    :ok
  end
end
