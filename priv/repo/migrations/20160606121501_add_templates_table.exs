defmodule Docput.Repo.Migrations.AddTemplatesTable do
  use Ecto.Migration

  def change do
    create table(:templates) do
      add :name, :string
      add :body, :text
      add :user_id, references(:users), null: false

      timestamps
    end

    create index(:templates, [:user_id], unique: true)
  end
end
