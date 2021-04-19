defmodule Blog.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use Blog.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Blog.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Blog.DataCase
    end
  end

  setup tags do
    if tags[:async] do
      raise "Can't run tests in async mode"
    end

    :ok = Blog.Repo.reset()
  end
end
