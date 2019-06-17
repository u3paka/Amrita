defmodule Amrita.Repo.Migrations.CreateCommentsRelations do
  use Ecto.Migration

  def change do

    create table(:comments_relations, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :comment_id, references(:comments, on_delete: :nothing)
      add :reply_id, references(:comments, on_delete: :nothing)
      timestamps()
    end

    create unique_index(:comments_relations, [:comment_id])
    create unique_index(:comments_relations, [:reply_id])
    create unique_index(:comments_relations, [:comment_id, :reply_id], primary_key: true)
  end
end
