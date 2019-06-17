defmodule Amrita.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :username, :string
      add :name, :string
      add :email, :string
      add :avatar_url, :string
      timestamps()
    end

    create unique_index(:users, [:username, :email])
  end
end
