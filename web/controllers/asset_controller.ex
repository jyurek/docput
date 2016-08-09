defmodule Docput.AssetController do
  use Docput.Web, :controller
  alias Ecto.DateTime
  alias Docput.Asset
  import Docput.SignedS3Form

  def new(conn, _params) do
    render_signed_form conn
  end

  def created(conn, %{"key" => key, "bucket" => bucket, "etag" => etag}) do
    url = s3_url_for(key: key, bucket: bucket)
    current_user = conn.assigns.current_user
    scope = assoc(current_user, :asset)
    case Repo.get_by(scope, url: url) do
      nil -> initialize_asset(url: url, user_id: current_user.id)
      x -> x
    end
    |> Asset.changset(etag: etag)
    |> Repo.insert_or_update

    render_signed_form conn,
      key: key,
      bucket: bucket,
      etag: etag
  end

  defp render_signed_form(conn, options \\ []) do
    now = DateTime.utc
    encoded_policy = encoded_policy(now, redirect_url(conn))
    render(conn, "index.html", Enum.into(options, %{}) |> Map.merge(%{
      key: nil,
      etag: nil,
      page_title: "Upload Asset to S3",
      policy: encoded_policy,
      signature: encoded_policy |> signature(now),
      bucket: Application.get_env(:docput, :s3)[:bucket],
      x_amz_date: now |> to_amz_date,
      credential_token: credential_token(now),
      redirect_url: redirect_url(conn)
    }))
  end

  defp initialize_asset(%{url: url, user_id: user_id}) do
    %Asset{
      url: url,
      user_id: user_id
    }
  end

  defp redirect_url(conn) do
    asset_url(conn, :created)
  end

  defp s3_url_for(%{key: key, bucket: bucket}) do
    "http://#{bucket}.s3.amazonaws.com/#{bucket}"
  end
end
