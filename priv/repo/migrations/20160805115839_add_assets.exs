defmodule Docput.Repo.Migrations.CreateAssets do
  use Ecto.Migration

  def change do
    create table(:assets) do
      add :url, :text, null: false
      add :etag, :string
      add :user_id, references(:users), null: false

      timestamps
    end

    create index(:assets, [:user_id])
    create index(:assets, [:url], unique: true)
  end
end
