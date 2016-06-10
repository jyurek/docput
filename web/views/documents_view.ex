defmodule Docput.DocumentsView do
  use Docput.Web, :view

  def selectify(enum) do
    enum |> Enum.map(&{&1.name, &1.id})
  end
end
