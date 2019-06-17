defmodule AmritaWeb.Note do
  use Phoenix.LiveView

  alias Amrita.Repo
  alias Amrita.Posts.{ Note }
  alias Amrita.Accounts.{ User }

  def render(assigns) do
    ~L"""
    <h1 class="title">Note id:<%= @note.id %></h1>
    <h2 class="subtitle">
    以下の質問についての回答です。
    </h2>

    <article class="message is-dark is-medium">
    <div class="message-body"><%= @note.text %> </div>
    </article>

<%= for c <- @comments do %>
<article class="media">
  <figure class="media-left">
    <p class="image is-64x64">
      <img src="https://bulma.io/images/placeholders/128x128.png">
    </p>
  </figure>
  <div class="media-content">
    <div class="content">
      <p>
        <strong><%= c.username %></strong> <small>@<%= c.id %></small> <small><%= c.relative_str %></small>
        <br>
<%= c.text %>
    </p>
    </div>
    <nav class="level is-mobile">
      <div class="level-left">
        <a class="level-item">
          <span class="icon is-small"><i class="fas fa-reply"></i></span>
        </a>
        <a class="level-item">
          <span class="icon is-small"><i class="fas fa-retweet"></i></span>
        </a>
        <a class="level-item">
          <span class="icon is-small"><i class="fas fa-heart"></i></span>
        </a>
      <button class="button is-outlined" phx-click="delete_comment" phx-value="<%= @note.id %>">del</button>
      </div>
    </nav>
  </div>
  <div class="media-right">
    <button class="delete"></button>
  </div>
</article>
<% end %>

<article class="media">
<figure class="media-left">
<p class="image is-64x64">
<img src="https://bulma.io/images/placeholders/128x128.png">
</p>
</figure>

<div class="media-content">
<div class="field">
<form phx-submit="add_comment">
<p class="control">
<textarea method="post" class="textarea" name="input" placeholder="Add a comment..."></textarea>
</p>
<button class="button is-info" type="submit">SUBMIT</button>
</form>
</div>
    </div>
</article>
   """
  end

  def mount(%{:path_params => %{"id" => id}} = session, socket) do
    IO.inspect(session)

    note = Note
    |> Repo.get(id)

    case KV.History.get_by_id(id) do
      {:ok, note} ->
        {:ok, assign(socket,
              note: note,
              comments: [%{:id => "aa",
                          :username => "Mr. Y",
                           :relative_str => "3 min",
                           :text => "lorem ipsum"
                          }]
          )}
      {:error, error} ->
          {:error, error}
    end
  end

  def handle_event("add_comment", %{"input" => input}, socket) do
 IO.inspect input

 Amrita.Posts.Note
 |> Amrita.Repo.get()

   new_socket =
   assign(socket,
     note_id: socket.assigns.note.id,
     comments: []
   )
    {:noreply, new_socket}
  end

end
