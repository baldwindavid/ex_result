defmodule ExResultTest do
  use ExUnit.Case

  alias ExResult

  require ExResult

  describe "is_result/1" do
    test "returns true for an ok tuple" do
      assert ExResult.is_result({:ok, 1}) == true
    end

    test "returns true for an error tuple" do
      assert ExResult.is_result({:error, :foo}) == true
    end

    test "returns false if not an ok or error tuple" do
      assert ExResult.is_result(1) == false
    end
  end

  describe "ok/1" do
    test "returns an ok tuple as-is" do
      assert ExResult.ok({:ok, 1}) == {:ok, 1}
    end

    test "returns an error tuple as-is" do
      assert ExResult.ok({:error, :foo}) == {:error, :foo}
    end

    test "wraps a non-ok tuple in an ok tuple" do
      assert ExResult.ok(1) == {:ok, 1}
    end
  end

  describe "error/1" do
    test "returns an error tuple as-is" do
      assert ExResult.error({:error, :foo}) == {:error, :foo}
    end

    test "returns an ok tuple as-is" do
      assert ExResult.error({:ok, 1}) == {:ok, 1}
    end

    test "wraps a non-error tuple in an error tuple" do
      assert ExResult.error(1) == {:error, 1}
    end
  end

  describe "ok?/1" do
    test "returns true for an ok tuple" do
      assert ExResult.ok?({:ok, 1}) == true
    end

    test "returns false for an error tuple" do
      assert ExResult.ok?({:error, :foo}) == false
    end

    test "returns false if not an ok or error tuple" do
      assert ExResult.ok?(1) == false
    end
  end

  describe "error?/1" do
    test "returns false for an ok tuple" do
      assert ExResult.error?({:ok, 1}) == false
    end

    test "returns true for an error tuple" do
      assert ExResult.error?({:error, :foo}) == true
    end

    test "returns false if not an ok or error tuple" do
      assert ExResult.error?(1) == false
    end
  end

  describe "unwrap/1" do
    test "unwraps a value from an ok tuple" do
      assert ExResult.unwrap({:ok, 1}) == 1
    end

    test "returns an error tuple as-is" do
      assert ExResult.unwrap({:error, :foo}) == {:error, :foo}
    end

    test "raises an error if not an ok or error tuple" do
      assert_raise ArgumentError, "1st argument: not an :ok or :error result tuple", fn ->
        ExResult.unwrap(1)
      end
    end
  end

  describe "unwrap!/1" do
    test "unwraps a value from an ok tuple" do
      assert ExResult.unwrap!({:ok, 1}) == 1
    end

    test "raises an error if an error tuple" do
      assert_raise ArgumentError, "1st argument: not an :ok result tuple", fn ->
        ExResult.unwrap!({:error, :foo})
      end
    end

    test "raises an error if not an ok or error tuple" do
      assert_raise ArgumentError, "1st argument: not an :ok result tuple", fn ->
        ExResult.unwrap!(1)
      end
    end
  end

  describe "update/2" do
    test "updates the value and returns in an ok tuple if it is an ok tuple" do
      assert ExResult.update({:ok, 1}, &(&1 + 1)) == {:ok, 2}
    end

    test "returns the result as-is if it is an error tuple" do
      assert ExResult.update({:error, :foo}, &(&1 + 1)) == {:error, :foo}
    end

    test "raises an error if not an ok or error tuple" do
      assert_raise ArgumentError, "1st argument: not an :ok or :error result tuple", fn ->
        ExResult.update(1, &(&1 + 1))
      end
    end
  end

  describe "update!/2" do
    test "updates the value and returns in an ok tuple if it is an ok tuple" do
      assert ExResult.update!({:ok, 1}, &(&1 + 1)) == {:ok, 2}
    end

    test "raises an error if an error tuple" do
      assert_raise ArgumentError, "1st argument: not an :ok result tuple", fn ->
        ExResult.update!({:error, :foo}, &(&1 + 1))
      end
    end

    test "raises an error if not an ok or error tuple" do
      assert_raise ArgumentError, "1st argument: not an :ok result tuple", fn ->
        ExResult.update!(1, &(&1 + 1))
      end
    end
  end

  describe "unwrap_and_update/2" do
    test "executes the given function if it is an ok tuple" do
      assert ExResult.unwrap_and_update({:ok, 1}, &(&1 + 1)) == 2
    end

    test "returns the result as-is if it is an error tuple" do
      assert ExResult.unwrap_and_update({:error, :foo}, &(&1 + 1)) == {:error, :foo}
    end

    test "raises an error if not an ok or error tuple" do
      assert_raise ArgumentError, "1st argument: not an :ok or :error result tuple", fn ->
        ExResult.unwrap_and_update(1, &(&1 + 1))
      end
    end
  end

  describe "unwrap_and_update!/2" do
    test "executes the given function if it is an ok tuple" do
      assert ExResult.unwrap_and_update!({:ok, 1}, &(&1 + 1)) == 2
    end

    test "raises an error if an error tuple" do
      assert_raise ArgumentError, "1st argument: not an :ok result tuple", fn ->
        ExResult.unwrap_and_update!({:error, :foo}, &(&1 + 1))
      end
    end

    test "raises an error if not an ok or error tuple" do
      assert_raise ArgumentError, "1st argument: not an :ok result tuple", fn ->
        ExResult.unwrap_and_update!(1, &(&1 + 1))
      end
    end
  end
end
