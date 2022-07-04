defmodule Blog.Utils do
  @moduledoc """
  Module containing various utility functions.
  """

  @doc """
  Given a term, wraps it in an `{:error, term}` tuple.

  ## Examples

      iex> Blog.Utils.return_error(:not_found)
      {:error, :not_found}

  If the given term is already wrapped in an `:ok` or `:error` tuple, it is
  re-wrapped as an `:error` accordingly.

      iex> Blog.Utils.return_error({:error, :already_an_error})
      {:error, :already_an_error}

      iex> Blog.Utils.return_error({:ok, :not_an_error})
      {:error, :not_an_error}

  """
  @spec return_error(term()) :: {:error, term()}
  def return_error({:ok, result}), do: {:error, result}
  def return_error({:error, result}), do: {:error, result}
  def return_error(result), do: {:error, result}
end
