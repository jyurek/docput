defmodule Docput.Template do
  use Docput.Web, :model

  schema "templates" do
    field :name
    field :body

    belongs_to :user_id, Docput.User
    has_many :documents, Docput.Document

    timestamps
  end
end
