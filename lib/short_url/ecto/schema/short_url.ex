defmodule ShortUrl.Schema.ShortUrl do
  use Ecto.Schema
  import Ecto.Changeset
  require Logger

  @primary_key {:hash, :string, []}
  schema "short_urls" do
    field :url, :string

    timestamps()
  end

  @required_fields [:hash, :url]
  @optional_fields []

  def changeset(record, params \\ %{}) do
    Logger.debug(~s|changeset event="#{inspect(record)} params="#{inspect(params)} |)

    record
    |> cast(params, @required_fields, @optional_fields)
    |> Ecto.Changeset.validate_required(@required_fields)
    |> unique_constraint(:hash)
  end
end
