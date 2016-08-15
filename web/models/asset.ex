defmodule Docput.Asset do
  use Docput.Web, :model

  schema "assets" do
    field :url
    field :etag
    belongs_to :user, Docput.User
    timestamps
  end

  def changeset(asset \\ %__MODULE__{}, options \\ %{}) do
    asset
    |> cast(options, ~w(url user_id))
  end

  def assign_file(asset \\ %__MODULE__{}, file) do
    bucket = Application.get_env(:docput, :s3)[:bucket]
    asset |> change(url: "http://#{bucket}.s3.amazonaws.com/#{file.filename}")
  end

  def assign_to_user(asset, user) do
    asset |> change(user_id: user.id)
  end
end
