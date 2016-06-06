defmodule Docput.Document do
  use Docput.Web, :model

  schema "documents" do
    field :name
    field :body

    belongs_to :template, Docput.Template
    belongs_to :user, Docput.User

    timestamps
  end
end
