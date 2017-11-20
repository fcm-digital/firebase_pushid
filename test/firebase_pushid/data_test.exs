defmodule FirebasePushid.DataTest do
  use ExUnit.Case
  alias FirebasePushid.Data
  doctest Data
  test "prev_ts" do
    {:ok, data} = Data.start_link
    assert Data.prev_ts(data) == 0
  end
  test "update_prev_ts" do
    {:ok, data} = Data.start_link
    assert Data.update(data, :prev_ts, 12) == :ok
    assert Data.prev_ts(data) == 12
  end
end
