defmodule ExResult do
  @moduledoc """
  Module for working with "result" tuples. Provides helpers for wrapping,
  unwrapping, and transforming result tuples.

  An opinionated stance on what constitutes a "result" tuple is taken here. A
  result tuple is a tuple of the form `{:ok, value}` or `{:error, value}` and
  NOTHING else.

  These helpers are most useful in pipelines.
  """

  @doc """
  Guard to check if a value is a result tuple. A result tuple is a tuple of the
  form `{:ok, value}` or `{:error, value}` and NOTHING else.

  ### Examples

      iex> is_result({:ok, 1})
      true

      iex> is_result({:error, :foo})
      true

      iex> is_result(1)
      false
  """
  defguard is_result(value)
           when is_tuple(value) and tuple_size(value) == 2 and elem(value, 0) in [:ok, :error]

  @doc """
  Helper function to wrap a value in an `:ok` tuple. Useful in pipelines where
  you want to wrap a value in an `:ok` tuple. If the value is already an `:ok`
  tuple, it will be returned as-is.

  ### Examples

      iex> ok(1)
      {:ok, 1}

      iex> ok({:ok, 1})
      {:ok, 1}
  """
  def ok({:ok, _value} = result), do: result
  def ok(value), do: {:ok, value}

  def error({:error, _value} = result), do: result
  def error(value), do: {:error, value}

  @doc """
  Helper function to check if a value is an `:ok` tuple. Useful in pipelines
  where you want to check if a value is an `:ok` tuple.

  ### Examples

      iex> ok?({:ok, 1})
      true

      iex> ok?({:error, :foo})
      false

      iex> ok?(1)
      false
  """
  def ok?({:ok, _value}), do: true
  def ok?(_other), do: false

  @doc """
  Helper function to check if a value is an `:error` tuple. Useful in pipelines
  where you want to check if a value is an `:error` tuple.

  ### Examples

      iex> error?({:ok, 1})
      false

      iex> error?({:error, :foo})
      true

      iex> error?(1)
      false
  """
  def error?({:error, _value}), do: true
  def error?(_other), do: false

  @doc """
  Helper function to unwrap the value from an `:ok` tuple, or to return an
  `:error` tuple as-is. If the value is not an `:ok` or `:error` tuple, an
  error will be raised. Useful in pipelines where you want to unwrap an `:ok`
  tuple, but pass an `:error` tuple through.

  ### Examples

      iex> unwrap({:ok, 1})
      1

      iex> unwrap({:error, :foo})
      {:error, :foo}

      iex> unwrap(1)
      ** (RuntimeError) Not an ok tuple
  """
  def unwrap({:ok, value}), do: value
  def unwrap({:error, _} = result), do: result
  def unwrap(_other_result), do: raise_not_result()

  @doc """
  Helper function to uwrap the value from an `:ok` tuple, or to raise an error
  if it is not an `:ok` tuple. Useful in pipelines where you want to modify an
  OK result, but raise an error if it is not an OK tuple.

  ### Examples

      iex> unwrap!({:ok, 1})
      1

      iex> unwrap!({:error, :foo})
      ** (RuntimeError) Not an ok tuple

      iex> unwrap!(1)
      ** (RuntimeError) Not an ok tuple
  """
  def unwrap!({:ok, value}), do: value
  def unwrap!(_other_result), do: raise_not_ok_result()

  @doc """
  Helper function to update the value of an `:ok` tuple, or to return an :error
  tuple as-is. If the value is not an `:ok` or `:error` tuple, an error will be
  raised. Useful in pipelines where you want to modify an OK result, but pass an
  error through.

  ### Examples

      iex> update({:ok, 1}, &(&1 + 1))
      {:ok, 2}

      iex> update({:error, :foo}, &(&1 + 1))
      {:error, :foo}

      iex> update(1, &(&1 + 1))
      ** (RuntimeError) Not an ok or error tuple
  """
  def update({:ok, value}, update_fn), do: {:ok, update_fn.(value)}
  def update({:error, _} = result, _update_fn), do: result
  def update(_other_result, _update_fn), do: raise_not_result()

  @doc """
  Helper function to update the value of an `:ok` tuple, or to raise an error
  if it is not an `:ok` tuple. Useful in pipelines where you want to modify an
  OK result, but raise an error if it is not an OK tuple.

  ### Examples

      iex> update!({:ok, 1}, &(&1 + 1))
      {:ok, 2}

      iex> update!({:error, :foo}, &(&1 + 1))
      ** (RuntimeError) Not an ok tuple

      iex> update!(1, &(&1 + 1))
      ** (RuntimeError) Not an ok tuple
  """
  def update!({:ok, value}, update_fn), do: {:ok, update_fn.(value)}
  def update!(_other_result, _update_fn), do: raise_not_ok_result()

  @doc """
  Helper function to unwrap the value from an `:ok` tuple and execute a
  transform on it, or to return an `:error` tuple as-is. If the value is not an
  `:ok` or `:error` tuple, an error will be raised. Useful in pipelines where
  you want to unwrap and transform an `:ok` tuple value, but pass an `:error`
  tuple through.

  ### Examples

      iex> unwrap_and_update({:ok, 1}, &(&1 * 2))
      2

      iex> unwrap_and_update({:error, :foo}, &(&1 * 2))
      {:error, :foo}

      iex> unwrap_and_update(1, &(&1 * 2))
      ** (RuntimeError) Not an ok tuple
  """
  def unwrap_and_update({:ok, value}, then_fn), do: then_fn.(value)
  def unwrap_and_update({:error, _} = result, _then_fn), do: result
  def unwrap_and_update(_other_result, _then_fn), do: raise_not_result()

  @doc """
  Helper function to execute a transform on the value of an `:ok` tuple, or to
  raise an error if it is not an `:ok` tuple. Useful in pipelines where you
  want to modify an OK result, but raise an error if it is not an OK tuple.

  ### Examples

      iex> unwrap_and_update!({:ok, 1}, &(&1 * 2))
      2

      iex> unwrap_and_update!({:error, :foo}, &(&1 * 2))
      ** (RuntimeError) Not an ok tuple

      iex> unwrap_and_update!(1, &(&1 * 2))
      ** (RuntimeError) Not an ok tuple
  """
  def unwrap_and_update!({:ok, value}, then_fn), do: then_fn.(value)
  def unwrap_and_update!(_other_result, _then_fn), do: raise_not_ok_result()

  defp raise_not_ok_result do
    raise ArgumentError, "1st argument: not an :ok result tuple"
  end

  defp raise_not_result do
    raise ArgumentError, "1st argument: not an :ok or :error result tuple"
  end
end
