defmodule ShortUrl.Repo do
  use Ecto.Repo,
    otp_app: :short_url,
    adapter: Ecto.Adapters.Postgres
end
