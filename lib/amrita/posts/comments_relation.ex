defmodule Amrita.Posts.CommentsRelation do
  use Amrita.Schema

  alias Amrita.Posts.Comment

  schema "comments_relations" do
    belongs_to :comment, Comment, primary_key: :comment_id
    belongs_to :reply, Comment, primary_key: :reply_id

    timestamps()
  end
end
