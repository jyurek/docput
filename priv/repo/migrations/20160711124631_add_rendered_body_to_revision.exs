defmodule Docput.Repo.Migrations.AddRenderedBodyToRevision do
  use Ecto.Migration

  def change do
    alter table(:revisions) do
      add :rendered_body, :text
    end
  end
end
