defmodule FirebasePushid.Bump do
  @doc """
  Updates last possible index to generate a not colisioning id
  example:
      iex> FirebasePushid.Bump.call([1, 2, 3, 4])
      [1, 2, 3, 5]

      iex> FirebasePushid.Bump.call([2, 63])
      [3, 0]
  """
  def call(list) when is_list(list) do
    increment_list(list)
  end

  defp increment_list(list) do
    list
    |> Enum.reverse
    |> inc_list([], :inc)
  end

  defp inc_list([], acc), do: acc
  defp inc_list([], acc, :inc), do: acc

  defp inc_list([63 = head | tail], acc) do
    inc_list(tail, [0 | acc], :inc)
  end
  defp inc_list([63 = head | tail], acc, :inc) do
    inc_list(tail, [0 | acc], :inc)
  end
  defp inc_list([head | tail], acc, :inc) do
    inc_list(tail, [head + 1 | acc])
  end
  defp inc_list([head | tail], acc) do
    inc_list(tail, [head | acc])
  end



end
