defmodule AmritaWeb.Search do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""

    <h1 class="title">Search</h1>
    <h2 class="subtitle">
    ここから質問フォームを検索できます。
    </h2 >

    <div>
    <form phx-submit="explosion">
    <button class="button" type="submit" name="">stop</button>
    </form>

    <form phx-change="search">
    <label class="label is-large" >Search</label>
    <div class="control">
      <textarea method="post" class="textarea is-medium" name="search" value="<%= @search %>" placeholder="質問文を入力してください。" <%= if @loading, do: "readonly" %> ></textarea>
      </div>
      </div>
      </form>

      <%= cond do %>
      <% @similars == [] && @search != "" -> %>
        (´；ω；｀)検索結果が見つかりませんでした。
        新しく追加しますか？
      <form phx-submit="toggle_form">
      <button class="button" type="submit" name="action">YES</button>
      </form>

      <div class="modal <%= if @form_open, do: "is-active" %>">
        <div class="modal-background"></div>
        <div class="modal-content">
      <form phx-submit="add_card">
      <div class="field">
      <textarea method="post" class="textarea is-medium" name="input" <%= if @loading, do: "readonly" %> ><%= @search %></textarea>
      <button class="button" type="submit" name="action">ADD</button>
      </form>
      </div>
      </div>

      <form phx-submit="toggle_form">
      <button class="modal-close is-large" type="submit" aria-label="close"></button>
      </form>
      </div>
       <% @similars == [] -> %>
      検索してみてください。 <% true -> %>
    <table class="table">
    <thread>
    <tr>
      <th>類似度</th>
      <th>文面</th>
      <th>いつごろ</th>
    </tr>
    </thead>

    <tbody>
    <%= for c  <- @similars do %>
    <tr>
    <td> <%= Float.round(elem(c.similarity, 1), 3) %> </td>
    <td> <%= c.text %> </td>
    <td> <%= c.relative_str %> </td>
    </tr>
    <% end %>
    </tbody>
    </table>
    <% end %>

    <table class="table is-fullwidth is-hoverable">
    <thead>
    <tr>
    <th>お題</th>
    <th>When</th>
    </tr>
    </thead>

    <tbody>
    <%= for c <- @notes do %>
    <tr onclick="location.href='<%= "/notes/#{c.id}" %> '">
    <td> <%= c.text %> </td>
    <td> <%= c.relative_str %> </td>
    </tr>
    <% end %>
    </table>
    </div>
    </div>
    """
  end

  def mount(_session, socket) do
    {:ok,
     assign(socket,
       search: "",
       similars: [],
       input: "",
       text_length: 0,
       loading: false,
       form_open: false,
       notes: KV.History.limit(100)
     )}
  end

  def handle_event("delete_comment", id, socket) do
    KV.History.delete_id(id)

    new_socket =
      socket
      |> assign(notes: KV.History.limit(100))

    {:noreply, new_socket}
  end

  def handle_event("add_card", %{"input" => input}, socket) do
    input
    |> KV.History.add()

    Mantra.Chant.vectorize(input, learn: true)

    new_socket =
      socket
      |> assign(
      comments: KV.History.limit(100),
      form_open: false,
      search: ""
    )

    {:noreply, new_socket}
  end

  def handle_event("explosion", _, socket) do
    exit(
      "黒より黒く闇より暗き漆黒に我が深紅の混淆を望みたもう。覚醒のとき来たれり。無謬の境界に落ちし理。無行の歪みとなりて現出せよ！踊れ踊れ踊れ、我が力の奔流に望むは崩壊なり。並ぶ者なき崩壊なり。万象等しく灰塵に帰し、深淵より来たれ！これが人類最大の威力の攻撃手段、これこそが究極の攻撃魔法、エクスプロージョン！"
    )

    {:noreply, socket}
  end

  def handle_event("toggle_form", _session, socket) do
    new_socket =
      socket
      |> assign(
      form_open: !socket.assigns.form_open
    )

    {:noreply, new_socket}
  end

  def handle_event("search", %{"search" => search}, socket) do
    IO.inspect search
    #IO.inspect Mantra.Chant.preprocess(search, learn: false)

    similars = KV.History.search(search)
    |> Flow.from_enumerable()
    |> Flow.map(fn
    %{:text => text} = card ->
      sim = text
      |> Mantra.Chant.similarity(search)
    card
    |> Map.put(:similarity, sim)
    end)
    |> Enum.to_list
   |> IO.inspect

    new_socket =
      socket
      |> assign(
        search: search,
        similars: similars
      )

    {:noreply, new_socket}
  end

  def handle_event("search_similar", %{"search" => search}, socket) do
    similars =
      search
      |> Mantra.Chant.find_similar()
      |> Enum.uniq()
      |> Enum.filter(fn {doc, score} ->
        score > 0
      end)

    new_socket =
      socket
      |> assign(similars: similars)

    {:noreply, new_socket}
  end

  def handle_event("detect_kanji", %{"q" => query}, socket) do
    IO.inspect(query)

    new_socket =
      socket
      |> assign(input: query)
      |> update(:output, fn x -> x <> "umi" end)
      |> update(:text_length, fn x -> String.length(socket.assigns.input) end)

    {:noreply, new_socket}
  end
end
