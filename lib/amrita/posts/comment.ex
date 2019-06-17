defmodule Amrita.Posts.Comment do
  use Amrita.Schema
  import Ecto.Changeset

  alias Amrita.Accounts.{User}
  alias Amrita.Posts.{Note, Comment}

  schema "comments" do
    field :message, :string

    belongs_to :user, User, foreign_key: :id, references: :id, define_field: false
    belongs_to :note, Note, foreign_key: :id, references: :id, define_field: false

    # has_many :comments_relations, Posts.CommentsRelation, foreign_key: :comment_id
    # has_many :comments, through: [:comments_relations, :reply]

    has_many :replies, Comment, foreign_key: :comment_id
    belongs_to :original_comment, Comment, foreign_key: :comment_id

#    has_many :reverse_comments_relations, through: [:reply_to, :reply_from]

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:message])
    |> validate_required([:user, :note, :message])
  end

  def reply(post, reply) do
    post
    |> Repo.preload([:replies, :original_comment])
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_assoc(:replies, [reply | post.replies])
    |> Repo.update
  end
end
