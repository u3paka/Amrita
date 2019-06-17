# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config
config :amrita, AmritaWeb.Endpoint,
  title: "Amrita: Phoenix LiveView FAQ system",
  navbar_title: "Amrita",
  footer_note: """
  Amrita by @u3paka. The source code is licensed
  MIT. The website content
  is licensed CC BY NC SA 4.0.
  """
config :amrita, Amrita.Repo,
  database: "amrita_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"

config :amrita,
  ecto_repos: [Amrita.Repo]

config :amrita, Amrita.Repo,
  migration_primary_key: [name: :uuid, type: :binary_id]

# Configures the endpoint
config :amrita, AmritaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "C5P+I513cvwxpVvmQdaBQ2hPv9FNmPf13LE+/9fXLurvJGOg91Vn1cSaxBxdNlxW",
  render_errors: [view: AmritaWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Amrita.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "1hkEALUcbFLjQKdXcmzbp5v4/80NY3IN"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
