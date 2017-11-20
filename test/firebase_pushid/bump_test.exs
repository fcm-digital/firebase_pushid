defmodule FirebasePushid.BumpTest do
  use ExUnit.Case
  alias FirebasePushid.Bump
  doctest Bump
  import Bump
  test "increment_list" do
    assert call([1, 2, 3, 4]) == [1, 2, 3, 5]
    assert call([63]) == [0]
    assert call([2, 63]) == [3, 0]
    assert call([3, 0]) == [3, 1]
    assert call([0, 63, 63]) == [1, 0, 0]
    assert call([0, 63, 63, 63]) == [1, 0, 0, 0]
  end
end
