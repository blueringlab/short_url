use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :short_url, ShortUrl.Repo,
  username: "postgres",
  password: "postgres",
  database: "short_url_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "short-url-db",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :short_url, ShortUrlWeb.Endpoint,
  http: [port: 4002],
  server: false

config :short_url, :hash_gen,
  max_duplicate_try: 10    # maximum try when duplicate hash key exist

# Print only warnings and errors during test
config :logger, level: :warn
