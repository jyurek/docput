defmodule Docput.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents) do
      add :name, :string
      add :body, :text
      add :user_id, references(:users), null: false
      add :template_id, references(:templates), null: false

      timestamps
    end

    create index(:documents, [:name], unique: true)
    create index(:documents, [:user_id])
  end
end
