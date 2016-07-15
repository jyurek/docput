defmodule Docput.HomeView do
  use Docput.Web, :view

  def time_of(revision) do
    {:ok, time} = Timex.format(
      revision.inserted_at,
      "%Y%m%d%H%M%S",
      :strftime
     )
    time
  end
end
