defmodule Docput.AssetController do
  use Docput.Web, :controller

  alias Docput.Asset
  alias Ecto.Changeset
  alias ExAws.S3

  def new(conn, _params) do
    conn
    |> assign(:asset, Asset.changeset)
    |> render "new.html"
  end

  def create(conn, %{"asset" => %{"file" => file}}) do
    case s3_put(file) do
      {:ok, response} ->
        conn
        |> assign(:asset, Asset.assign_file(file)
                          |> Asset.assign_to_user(conn.assigns.current_user)
                          |> Repo.insert)
        |> put_flash(:notice, "Uploaded!")
      {:error, error} ->
        IO.inspect(error)
        conn
        |> assign(:message, inspect(error))
        |> put_flash(:error, "Unable to upload.")
        |> assign(:asset, Asset.changeset)
    end
    |> redirect(to: asset_path(conn, :new))
  end

  defp s3_put(file) do
    case File.read(file.path) do
      {:ok, data} ->
        ExAws.S3.put_object(
          Application.get_env(:docput, :s3)[:bucket],
          file.filename,
          data,
          [acl: :public_read,
          content_encoding: file.content_type]
        )
        |> ExAws.request
      error -> error
    end
  end
end
