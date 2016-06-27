defmodule Docput.AuthController do
  use Docput.Web, :controller

  alias Docput.Repo
  alias Docput.User
  alias Docput.Queries

  def google(conn, _params) do
    conn
    |> redirect(external: strategy.authorize_url!(auth_url(conn, :callback)))
  end

  def callback(conn, %{"code" => code}) do
    token = strategy.get_token!(auth_url(conn, :callback), code: code)
    case get_userinfo(token) do
      %{"email" => email, "name" => name} ->
        case find_or_insert_user(email, name) do
          nil -> 
          conn
          |> put_flash(:error, gettext("Can't work with this."))
          |> redirect(external: "/")
          user ->
            conn
            |> put_session(:user_id, user.id)
            |> redirect(external: home_path(conn, :index))
        end
      %{"error" => error} ->
        conn
        |> put_flash(:error, gettext("There was a problem logging you in."))
        |> redirect(to: home_path(conn, :index))
    end
  end
  def callback(conn, %{"error" => error_message}) do
    conn
    |> put_flash(:error, error_message)
    |> redirect(external: "/")
  end

  def sign_out(conn, _params) do
    conn
    |> put_session(:user_id, nil)
    |> redirect(to: "/")
  end

  defp strategy do
    GoogleStrategy
  end

  defp get_userinfo(token) do
    OAuth2.AccessToken.get!(token, "/oauth2/v1/userinfo?alt=json")
    |> Map.get(:body)
  end

  defp get_tokeninfo!(id_token) do
    strategy.get_tokeninfo!(id_token)
  end

  defp find_or_insert_user(email, name) do
    find_user(email) || insert_user(email, name)
  end

  defp find_user(email) do
    Queries.User.with_email(email) |> Repo.one
  end

  defp insert_user(email, name) do
    changeset = User.create_changeset(%User{}, %{email: email, name: name})

    case Repo.insert(changeset) do
      {:ok, user} ->
        user
      {:error, _changeset} ->
        nil
    end
  end

  defp redirect_after_success_uri(conn, token) do
    "#{get_session(conn, :redirect_after_success_uri)}/#{token}"
  end
end
