defmodule Docput.Asset do
  use Docput.Web, :model

  schema "assets" do
    field :url
    field :etag
    belongs_to :user, Docput.User
    timestamps
  end

  def changeset(asset, params \\ %{}) do
    asset |> cast(params, ~w(url user_id))
  end
end
