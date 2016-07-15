defmodule Docput.Revision do
  use Docput.Web, :model
  use Timex.Ecto.Timestamps

  schema "revisions" do
    field :version
    field :body

    belongs_to :user, Docput.User
    belongs_to :layout, Docput.Layout
    belongs_to :document, Docput.Document

    timestamps
  end

  def changeset(revision \\ %__MODULE__{}, params \\ %{}) do
    revision
    |> cast(params, ~w(body user_id layout_id document_id))
    |> cast_assoc(:layout)
    |> assign_version
  end

  def assign_version(revision) do
    revision
    |> change(version: Base.encode16(:crypto.hash(:md5, "#{:os.system_time}")))
  end
end
