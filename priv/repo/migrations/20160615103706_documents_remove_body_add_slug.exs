defmodule Docput.Repo.Migrations.DocumentsRemoveBodyAddSlug do
  use Ecto.Migration

  def up do
    alter table(:documents) do
      remove :body
      remove :template_id
      add :slug, :string
    end

    create index(:documents, [:slug], unique: true)
  end

  def down do
    drop index(:documents, [:slug])

    alter table(:documents) do
      remove :slug
      add :body, :text
      add :template_id, references(:template), null: false
    end
  end
end
