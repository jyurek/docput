defmodule Docput.User do
  use Docput.Web, :model

  schema "users" do
    field :email
    field :token
    field :name

    has_many :documents, Docput.Document
    has_many :layouts, Docput.Layout

    timestamps
  end

  def create_changeset(user, params) do
    user
    |> cast(params, ~w(email), ~w(name))
    |> generate_token
  end

  defp generate_token(changeset) do
    token = SecureRandom.urlsafe_base64(32)
    put_change changeset, :token, token
  end
end
