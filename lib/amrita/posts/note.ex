defmodule Amrita.Posts.Note do
  use Amrita.Schema
  import Ecto.Changeset
  alias Amrita.Repo
  alias Amrita.Accounts

  schema "notes" do
    field :message, :string

    belongs_to :user, Accounts.User
    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:message])
    |> validate_required([:message])
  end

  def user_note(user, attrs) do
    Ecto.build_assoc(user, :notes)
    |> changeset(attrs)
#|> Ecto.Changeset.change(message: "nugaaaaaaaadfadaaaaa")
    |> Amrita.Repo.insert!
  end
end
