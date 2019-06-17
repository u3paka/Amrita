defmodule Amrita.Posts.Note do
  use Amrita.Schema
  import Ecto.Changeset

  alias Amrita.Accounts

  schema "notes" do
    field :message, :string

    belongs_to :user, Accounts.User, foreign_key: :id, references: :parent_id, define_field: false
    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:user, :message])
    |> validate_required([:user, :message])
  end
end
