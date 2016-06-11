defmodule Docput.LayoutView do
  use Docput.Web, :view

  def signed_in?(conn) do
    case conn.assigns[:current_user] do
      nil -> false
      _ -> true
    end
  end
end
