defmodule ShortUrl.Repo.Migrations.CreateShortUrlTable do
  use Ecto.Migration

  def change do
    create table("short_urls") do
      add :hash,  :string, size: 32
      add :url,   :string, size: 512

      timestamps()
    end

    create index("short_urls", [:hash], unique: true)
  end
end
