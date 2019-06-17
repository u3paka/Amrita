defmodule Amrita.Repo.Migrations.CommentBelongsToNote do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :note_id, references(:notes)
      add :comment_id, references(:comments)
    end
  end
end
