defmodule Docput.Repo.Migrations.RenameTemplatesToLayouts do
  use Ecto.Migration

  def change do
    rename table(:templates), to: table(:layouts)
  end
end
