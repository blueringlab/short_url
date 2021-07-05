# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :short_url,
  ecto_repos: [ShortUrl.Repo]

# Configures the endpoint
config :short_url, ShortUrlWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wFz4bzdEfCAm/p4u+QoTV6ijry+P68VW/mT2EQYiSa/JK7otyw7kKLUjC2VT6rye",
  render_errors: [view: ShortUrlWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ShortUrl.PubSub,
  live_view: [signing_salt: "bLJcPMFv"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :cors_plug,
  origin: [ ~r/\\*/ ],
  max_age: 86400,
  methods: ["GET", "POST"]

config :short_url, :hash_gen,
  max_duplicate_try: 100    # maximum try when duplicate hash key exist

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
