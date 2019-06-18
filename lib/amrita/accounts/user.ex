defmodule Amrita.Accounts.User do
  use Amrita.Schema
  import Ecto.Changeset
  alias Amrita.Repo
  alias Amrita.Posts

  schema "users" do
    field :name, :string
    field :username, :string
    field :email, :string
    field :avatar_url, :string
    timestamps()

    has_many :notes, Posts.Note
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> Repo.preload(:notes)
    |> cast(attrs, [:username, :name, :email])
    |> cast_assoc(:notes, with: &Posts.Note.changeset/2)
    |> validate_required([:username])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end
end
