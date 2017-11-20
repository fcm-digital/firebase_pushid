defmodule FirebasePushid.CacheTest do
  use ExUnit.Case
  alias FirebasePushid.Cache
  doctest Cache
  test "prev_ts" do
    {:ok, data} = Cache.start_link(:independent)
    assert Cache.prev_ts(data) == 0
  end
  test "update_prev_ts" do
    {:ok, data} = Cache.start_link(:independent)
    assert Cache.update(data, :prev_ts, 12) == :ok
    assert Cache.prev_ts(data) == 12
  end
end
