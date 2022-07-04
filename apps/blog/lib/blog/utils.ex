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

  @doc """
  Given a term, wraps it in an `{:ok, term}` tuple.

  ## Examples

      iex> Blog.Utils.return_ok(:success)
      {:ok, :success}

  If the given term is already wrapped in an `:ok` or `:error` tuple, it is
  re-wrapped as an `:ok` accordingly.

      iex> Blog.Utils.return_ok({:ok, :already_success})
      {:ok, :already_success}

      iex> Blog.Utils.return_ok({:error, :not_found})
      {:ok, :not_found}

  """
  @spec return_ok(term()) :: {:ok, term()}
  def return_ok({:ok, result}), do: {:ok, result}
  def return_ok({:error, result}), do: {:ok, result}
  def return_ok(result), do: {:ok, result}

  @doc """
  Predicate function returning `true` if given term is either `:ok` or an `{:ok, term}`
  tuple.

  ## Examples

      iex> Blog.Utils.ok?(:ok)
      true

      iex> Blog.Utils.ok?({:ok, :success})
      true

      iex> Blog.Utils.ok?(:otherwise)
      false

      iex> Blog.Utils.ok?(false)
      false

  """
  @spec ok?(term()) :: boolean()
  def ok?(:ok), do: true
  def ok?({:ok, _result}), do: true
  def ok?(_otherwise), do: false
end
