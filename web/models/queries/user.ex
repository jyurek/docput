defmodule Docput.Queries.User do
  alias Docput.User
  import Ecto.Query

  def with_email(email) do
    from u in User, where: u.email == ^email
  end
end
