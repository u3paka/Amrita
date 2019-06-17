defmodule KV.History do
  use Agent
  use Timex

  def start_link(initial_state \\ []) do
    Agent.start(fn -> initial_state end, name: __MODULE__)
  end

  def make_note(text, id: id), do: make_note(text, id: id, created_at: Timex.now("Japan"))

  def make_note(text, id: id, created_at: created_at) when is_bitstring(created_at) do
    case Timex.parse(created_at, "{ISO:Extended}") do
      {:ok, parsed_time} ->
        make_note(text, id: id, created_at: parsed_time)

      {:error, err} ->
        IO.inspect(err)
        make_note(text, id: id)
    end
  end

  def make_note(text, id: id, created_at: created_at) do
    %{
      :id => id,
      :created_at => created_at,
      :text => text
    }
  end

  def add(text, opts \\ [id: Ecto.UUID.generate(), created_at: Timex.now("Japan")]) do
    new_note = make_note(text, opts)

    Agent.update(__MODULE__, fn state ->
      [new_note | state]
    end)

    new_note
  end

  def get_by_id(id) do
    Agent.get(__MODULE__, fn state ->
      state
      |> Enum.find(&(&1.id == id))
    end)
    |> case do
      nil -> {:error, "can not find id: #{id}"}
      card -> {:ok, card}
    end
  end

  def reply_to(note, text, opts) do
    Agent.update(__MODULE__, fn state ->
      new_note = make_note(text, opts)
      state |> Enum.map(&(&1.id == note.id))
      [new_note | state]
    end)
  end

  def assoc(base_note, key_str, note) when is_bitstring(key_str),
    do: assoc(base_note, String.to_atom(key_str), note)

  def assoc(base_note, key_atom, note) do
    base_note
    |> Map.put(key_atom, note)
  end

  def restore(new_state) do
    Agent.update(__MODULE__, fn _state -> new_state end)
  end

  def search(""), do: []

  def search(text) do
    limit(100)
    |> Enum.filter(&String.contains?(&1.text, text))
  end

  def refresh_time(notes) do
    notes
    |> Flow.from_enumerable()
    |> Flow.map(fn x ->
      {:ok, relative_str} =
        x.created_at
        |> Timex.format("{relative}", :relative)

      Map.put(x, :relative_str, relative_str)
    end)
    |> Enum.to_list()
    |> Enum.sort(&(Timex.compare(&1.created_at, &2.created_at) == -1))
  end

  def limit(n) do
    Agent.get(__MODULE__, fn state ->
      state
      |> Enum.take(n)
      |> refresh_time()
    end)
  end

  def delete_id(id) do
    Agent.update(__MODULE__, fn state ->
      state
      |> Enum.filter(fn x -> x.id != id end)
    end)
  end

  def delete_all() do
    Agent.update(__MODULE__, fn _state -> [] end)
  end

  def explosion() do
    exit(
      "黒より黒く闇より暗き漆黒に我が深紅の混淆を望みたもう。覚醒のとき来たれり。無謬の境界に落ちし理。無行の歪みとなりて現出せよ！踊れ踊れ踊れ、我が力の奔流に望むは崩壊なり。並ぶ者なき崩壊なり。万象等しく灰塵に帰し、深淵より来たれ！これが人類最大の威力の攻撃手段、これこそが究極の攻撃魔法、エクスプロージョン！"
    )
  end
end
