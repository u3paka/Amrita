defmodule KV.Comment do
  use Agent
  use Timex

  def start_link(initial_map \\ %{}) do
    Agent.start(fn -> initial_map end, name: __MODULE__)
  end

  def make_comment(username, message), do: make_comment(username, message, Ecto.UUID.generate())

  def make_comment(username, message, id),
    do: make_comment(username, message, id, Timex.now("Japan"))

  def make_comment(username, message, id, created_at) when is_bitstring(created_at) do
    case Timex.parse(created_at, "{ISO:Extended}") do
      {:ok, parsed_time} ->
        make_comment(username, message, id, parsed_time)

      {:error, err} ->
        IO.inspect(err)
        make_comment(username, message, id, Timex.now("Japan"))
    end
  end

  def make_comment(username, message, id, created_at) do
    %{
      :id => id,
      :created_at => created_at,
      :username => username,
      :message => message,
      :note_id => nil,
      :reply_to => nil
    }
  end

  def add(username, message \\ "") do
    Agent.update(__MODULE__, fn state ->
      state
      |> Map.update(username, [make_comment(username, message)], fn x ->
        [make_comment(username, message) | x]
      end)
    end)
  end

  def get(username) do
    Agent.get(__MODULE__, fn state -> state |> Map.get(username, 0) end)
  end

  def restore(new_state) do
    Agent.update(__MODULE__, fn _state -> new_state end)
  end

  def all() do
    Agent.get(__MODULE__, fn state ->
      state
      |> Enum.reduce([], fn {_username, comments}, acc ->
        acc ++ comments
      end)
      |> Enum.sort(&(Timex.compare(&1.created_at, &2.created_at) == -1))
      |> Enum.map(fn x ->
        {:ok, relative_str} = x.created_at |> Timex.format("{relative}", :relative)
        Map.put(x, :relative_str, relative_str)
      end)
    end)
  end

  def upgrade() do
    Agent.update(__MODULE__, fn state ->
      state
      |> Enum.reduce(%{}, fn
        %{"username" => username, "message" => message, "created_at" => created_at, "id" => id}, acc ->
          IO.puts("ID #{id} is Inserted again.")

          Map.update(acc, username, [make_comment(username, message, id, created_at)], fn x ->
            [make_comment(username, message, id, created_at) | x]
          end)

        %{"username" => username, "message" => message, "created_at" => created_at}, acc ->
          id = Ecto.UUID.generate()
          IO.puts("ID #{id} is newly Inserted.")

          Map.update(acc, username, [make_comment(username, message, id, created_at)], fn x ->
            [make_comment(username, message, id, created_at) | x]
          end)
      end)
    end)
  end

  def delete_all() do
    Agent.update(__MODULE__, fn _state -> %{} end)
  end

  def explosion() do
    exit(
      "黒より黒く闇より暗き漆黒に我が深紅の混淆を望みたもう。覚醒のとき来たれり。無謬の境界に落ちし理。無行の歪みとなりて現出せよ！踊れ踊れ踊れ、我が力の奔流に望むは崩壊なり。並ぶ者なき崩壊なり。万象等しく灰塵に帰し、深淵より来たれ！これが人類最大の威力の攻撃手段、これこそが究極の攻撃魔法、エクスプロージョン！"
    )
  end
end
