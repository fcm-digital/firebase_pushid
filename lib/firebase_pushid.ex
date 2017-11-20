defmodule FirebasePushid do
  @moduledoc """
  Generates a timestamp based id as Firebase does.
  If colision will happen because same timestamp has been already created
  it will increment the random string.
  """
  alias FirebasePushid.Data
  alias FirebasePushid.Bump

  @doc """
  Generates Firebase id.
  It caches with previous timestamp.
  If same timestamp is stored in the data if will generate an incremental id
  in base 64 trying to increment the last possible character.
  ex:
  1) -Kyukibfm7T0jJT_Deyr
  2) -Kyukibfm7T0jJT_Deys

  If last can not be incremented will update the next
  ex:
  1) -KyukibfiPUIPSaeXo9z
  2) -KyukibfiPUIPSaeXoA-
  3) -KyukibfiPUIPSaeXoA0
  ...
  x) -KyukibfiPUIPSaeXoAz
  x) -KyukibfiPUIPSaeXoB-
  x) -KyukibfiPUIPSaeXoB0
  """
  def generate do
    # { :ok, data } = Data.start_link(:independent)
    next_id(Data, seed())
  end


  @push_charts "-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz"
  @charts_list (@push_charts |> String.codepoints)

  @doc """
  Generates Firebase id with previous cached data (FirebasePushid.Data) and
  timestamp.
  """
  def next_id(data, ts) do
    is_dup = (ts == Data.prev_ts(data))

    Data.update(data, :prev_ts, ts)
    id = build_ts_char_list(ts) |> Enum.join

    if is_dup do
      increment_list(data)
    else
      Data.set_random_nums(data, random_nums(12))
    end

    tail = Data.random_nums(data)
           |> string_by_nums

    id = id <> tail
    unless String.length(id) == 20 do
      raise "not valid"
    end
    id
  end

  @doc """
  Updates last possible index to generate a not colisioning id
  example:
      iex> FirebasePushid.increment_list([1, 2, 3, 4])
      [1, 2, 3, 5]

      iex> FirebasePushid.increment_list([2, 63])
      [3, 0]
  """
  def increment_list(list) when is_list(list), do: Bump.call(list)
  def increment_list(data) when is_pid(data)  do
    new_list = Data.random_nums(data)
               |> Bump.call()
    Data.set_random_nums(data, new_list)
  end

  @doc """
  Returns a `List` with 8 characters based on unix timestamp
  example:
      iex> 1510647799 |> FirebasePushid.build_ts_char_list
      ["-", "-", "0", "P", "1", "e", "U", "r"]
  """
  def build_ts_char_list(ts) do
    { ts_chars, 0 } = [] |> build_ts_char_list(ts, 8)
    ts_chars
  end

  defp build_ts_char_list(acc, ts, 0), do: { acc, ts }
  defp build_ts_char_list(acc, ts, i) do
    char = @charts_list |> Enum.at(rem(ts, 64))
    next_ts = Float.floor(ts / 64) |> round
    [char | acc]
    |> build_ts_char_list(next_ts, i - 1)
  end

  @doc """
  Generates the amount of random numbers all to the max of 63
  output example: [41, 7, 5, 22, 40, 5, 35, 42]

  example:
      iex> FirebasePushid.random_nums(8)
      ...> |> Enum.count
      8
  """
  def random_nums(amount), do: random_nums([], amount)
  def random_nums(acc, 0), do: acc
  def random_nums(acc, i) do
    num = (:rand.uniform() * 64) |> Float.floor |> round
    [num | acc]
    |> random_nums(i - 1)
  end

  @doc """
  Given a array of numbers until 63, generates a string

  example:
      iex> [41, 7, 5, 22, 40, 5, 35, 42]
      ...> |> FirebasePushid.string_by_nums
      "d64Lc4Ye"
  """
  def string_by_nums(int_list) do
    char_by_nums(int_list) |> Enum.reverse |> Enum.join
  end
  defp char_by_nums(random_int_list) do
    char_by_nums(random_int_list, [])
  end
  defp char_by_nums([], acc), do: acc
  defp char_by_nums([head | tail], acc) do
    char = @charts_list |> Enum.at(head)
    char_by_nums(tail, [char | acc])
  end

  @doc """
  Returns the current timestamp in milliseconds
  """
  def seed do
    DateTime.utc_now |> DateTime.to_unix(:millisecond)
  end
end
