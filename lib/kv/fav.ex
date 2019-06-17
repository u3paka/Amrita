defmodule KV.Fav do
  use Agent

  def start_link(initial_map \\ %{}) do
    Agent.start(fn -> initial_map end, name: __MODULE__)
  end

  def add(user, count \\ 1) do
    Agent.update(__MODULE__, fn state -> state |> Map.update(user, 1, fn x -> x + count end) end)
  end

  def get(user) do
    Agent.get(__MODULE__, fn state -> state |> Map.get(user, 0) end)
  end

  def get_sum() do
    Agent.get(__MODULE__, fn state ->
      state
      |> Enum.reduce(0, fn {_user, x}, acc ->
        acc + x
      end)
    end)
  end

  def restore(new_state) do
    Agent.update(__MODULE__, fn _state -> new_state end)
  end

  def all() do
    Agent.get(__MODULE__, fn state ->
      state
    end)
  end

  def explosion() do
    exit(
      "黒より黒く闇より暗き漆黒に我が深紅の混淆を望みたもう。覚醒のとき来たれり。無謬の境界に落ちし理。無行の歪みとなりて現出せよ！踊れ踊れ踊れ、我が力の奔流に望むは崩壊なり。並ぶ者なき崩壊なり。万象等しく灰塵に帰し、深淵より来たれ！これが人類最大の威力の攻撃手段、これこそが究極の攻撃魔法、エクスプロージョン！"
    )
  end
end
