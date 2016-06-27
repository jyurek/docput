defmodule Docput.Repo.Migrations.AddRevisionsTable do
  use Ecto.Migration

  def change do
    create table(:revisions) do
      add :version, :string
      add :body, :text
      add :user_id, references(:users), null: false
      add :layout_id, references(:layouts), null: false
      add :document_id, references(:documents), null: false
    end
  end
end
