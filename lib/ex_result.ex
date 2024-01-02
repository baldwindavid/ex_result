defmodule ExResult do
  @moduledoc """
  Module for working with "result" tuples. Provides helpers for wrapping,
  unwrapping, and transforming result tuples.

  An opinionated stance on what constitutes a "result" tuple is taken here. A
  result tuple is a tuple of the form `{:ok, value}` or `{:error, value}` and
  NOTHING else.

  These helpers are most useful in pipelines.
  """

  @type ok_result :: {:ok, any()}
  @type error_result :: {:error, any()}
  @type result :: ok_result() | error_result()
  @type update_fn :: (any() -> any())

  @doc """
  Guard to check if a value is a result tuple.

  A result tuple is a tuple of the form `{:ok, value}` or `{:error, value}` and
  NOTHING else.

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
  Wraps a value in an `:ok` tuple.

  If the value is already an `:ok` tuple, it will be returned as-is.

  ### Examples

      iex> ok(1)
      {:ok, 1}

      iex> ok({:ok, 1})
      {:ok, 1}
  """
  @spec ok(any()) :: ok_result()
  def ok({:ok, _value} = result), do: result
  def ok(value), do: {:ok, value}

  @doc """
  Wraps a value in an `:error` tuple.

  If the value is already an `:error` tuple, it will be returned as-is.

  ### Examples

      iex> error(:foo)
      {:error, :foo}

      iex> error({:error, :foo})
      {:error, :foo}
  """
  @spec error(any()) :: error_result()
  def error({:error, _value} = result), do: result
  def error(value), do: {:error, value}

  @doc """
  Checks if a value is an `:ok` tuple.

  ### Examples

      iex> ok?({:ok, 1})
      true

      iex> ok?({:error, :foo})
      false

      iex> ok?(1)
      false
  """
  @spec ok?(any()) :: boolean()
  def ok?({:ok, _value} = _result), do: true
  def ok?(_other), do: false

  @doc """
  Checks if a value is an `:error` tuple.

  ### Examples

      iex> error?({:ok, 1})
      false

      iex> error?({:error, :foo})
      true

      iex> error?(1)
      false
  """
  @spec error?(any()) :: boolean()
  def error?({:error, _value} = _result), do: true
  def error?(_other), do: false

  @doc """
  Unwraps a value from an `:ok` tuple or returns an `:error` tuple as-is.

  If the value is not an `:ok` or `:error` tuple, an error will be raised.

  ### Examples

      iex> unwrap({:ok, 1})
      1

      iex> unwrap({:error, :foo})
      {:error, :foo}

      iex> unwrap(1)
      ** (ArgumentError) 1st argument: not an :ok or :error result tuple
  """
  @spec unwrap(result()) :: any()
  def unwrap({:ok, value} = _result), do: value
  def unwrap({:error, _} = result), do: result
  def unwrap(_other_result), do: raise_not_result()

  @doc """
  Unwraps a value from an `:ok` tuple or raises if not an `:ok` tuple.

  ### Examples

      iex> unwrap!({:ok, 1})
      1

      iex> unwrap!({:error, :foo})
      ** (ArgumentError) 1st argument: not an :ok result tuple

      iex> unwrap!(1)
      ** (ArgumentError) 1st argument: not an :ok result tuple
  """
  @spec unwrap!(ok_result()) :: any()
  def unwrap!({:ok, value} = _result), do: value
  def unwrap!(_other_result), do: raise_not_ok_result()

  @doc """
  Updates the "value" of an `:ok` tuple or returns an :error tuple as-is.

  If the value is not an `:ok` or `:error` tuple, an error will be raised.

  ### Examples

      iex> update({:ok, 1}, &(&1 + 1))
      {:ok, 2}

      iex> update({:error, :foo}, &(&1 + 1))
      {:error, :foo}

      iex> update(1, &(&1 + 1))
      ** (ArgumentError) 1st argument: not an :ok or :error result tuple
  """
  @spec update(result(), update_fn()) :: result()
  def update({:ok, value} = _result, update_fn), do: {:ok, update_fn.(value)}
  def update({:error, _} = result, _update_fn), do: result
  def update(_other_result, _update_fn), do: raise_not_result()

  @doc """
  Updates the "value" of an `:ok` tuple or raises if not an `:ok` tuple.

  ### Examples

      iex> update!({:ok, 1}, &(&1 + 1))
      {:ok, 2}

      iex> update!({:error, :foo}, &(&1 + 1))
      ** (ArgumentError) 1st argument: not an :ok result tuple

      iex> update!(1, &(&1 + 1))
      ** (ArgumentError) 1st argument: not an :ok result tuple
  """
  @spec update!(ok_result(), update_fn()) :: ok_result()
  def update!({:ok, value} = _result, update_fn), do: {:ok, update_fn.(value)}
  def update!(_other_result, _update_fn), do: raise_not_ok_result()

  @doc """
  Unwraps the "value" from an `:ok` tuple and executes a transform on it or
  returns an `:error` tuple as-is.

  If the value is not an `:ok` or `:error` tuple, an error will be raised.

  ### Examples

      iex> unwrap_and_update({:ok, 1}, &(&1 * 2))
      2

      iex> unwrap_and_update({:error, :foo}, &(&1 * 2))
      {:error, :foo}

      iex> unwrap_and_update(1, &(&1 * 2))
      ** (ArgumentError) 1st argument: not an :ok or :error result tuple
  """
  @spec unwrap_and_update(result(), update_fn()) :: result()
  def unwrap_and_update({:ok, value} = _result, then_fn), do: then_fn.(value)
  def unwrap_and_update({:error, _} = result, _then_fn), do: result
  def unwrap_and_update(_other_result, _then_fn), do: raise_not_result()

  @doc """
  Executes a transform on the "value" of an `:ok` tuple or raises if not an
  `:ok` tuple.

  ### Examples

      iex> unwrap_and_update!({:ok, 1}, &(&1 * 2))
      2

      iex> unwrap_and_update!({:error, :foo}, &(&1 * 2))
      ** (ArgumentError) 1st argument: not an :ok result tuple

      iex> unwrap_and_update!(1, &(&1 * 2))
      ** (ArgumentError) 1st argument: not an :ok result tuple
  """
  @spec unwrap_and_update!(ok_result(), update_fn()) :: any()
  def unwrap_and_update!({:ok, value} = _result, then_fn), do: then_fn.(value)
  def unwrap_and_update!(_other_result, _then_fn), do: raise_not_ok_result()

  defp raise_not_ok_result do
    raise ArgumentError, "1st argument: not an :ok result tuple"
  end

  defp raise_not_result do
    raise ArgumentError, "1st argument: not an :ok or :error result tuple"
  end
end
