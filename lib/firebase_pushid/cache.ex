defmodule FirebasePushid.Cache do
  defstruct prev_ts: 0, random_nums: [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]

  def start_link do
    Agent.start_link(fn -> %__MODULE__{} end, name: __MODULE__)
  end

  def start_link(:independent) do
    Agent.start_link(fn -> %__MODULE__{} end)
  end

  def prev_ts(pid) do
    Agent.get(pid, fn (d) -> d.prev_ts end)
  end

  @doc """
  Gets and updates prev_ts
  example:

      iex> {:ok, data} = FirebasePushid.Cache.start_link(:independent)
      ...> FirebasePushid.Cache.get_and_update(data, :prev_ts, 5)
      5
  """
  def get_and_update(pid, :prev_ts, value) do
    Agent.get_and_update(
      pid,
      fn state -> {value, %__MODULE__{state | prev_ts: value}} end
    )
  end

  @doc """
  Updates prev_ts
  example:

      iex> {:ok, data} = FirebasePushid.Cache.start_link(:independent)
      ...> FirebasePushid.Cache.update(data, :prev_ts, 5)
      :ok
  """
  def update(pid, :prev_ts, value) do
    Agent.update(pid, fn state -> %__MODULE__{state | prev_ts: value} end)
  end

  def random_nums(pid) do
    Agent.get(pid, fn (d) -> d.random_nums end)
  end

  def set_random_nums(pid, nums) do
    Agent.update(pid, fn (state) -> %__MODULE__{state | random_nums: nums} end)
  end
end
