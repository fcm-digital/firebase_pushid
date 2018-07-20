defmodule FirebasePushidTest do
  use ExUnit.Case
  doctest FirebasePushid
  import FirebasePushid

  test 'generate' do
    assert generate()
  end

  test "new_id" do
    { :ok, data } = FirebasePushid.Cache.start_link(:independent)
    ts = 1510666856939
    id = next_id(data, ts)
    assert id
    new_id = next_id(data, ts)
    assert new_id != id
    assert String.slice(id, 0..7) == "-Kyukibf"
    assert String.slice(id, 0..7) == String.slice(new_id, 0..7)
    assert String.last(id) != String.last(new_id)
    assert String.at(id, 17) == String.at(new_id, 17)
    another_id = next_id(data, 1510666856950)
    assert String.slice(another_id, 0..7) != "-Kyukibf"
  end

  test "Multiple calls with FirebasePushid.Cache" do
    for _ <- 1..100, do: generate()
  end
end
