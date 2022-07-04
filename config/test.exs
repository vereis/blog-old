import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :blog, Blog.Repo,
  database: System.fetch_env!("POSTGRES_DB") <> "_test#{System.get_env("MIX_TEST_PARTITION")}",
  username: System.fetch_env!("POSTGRES_USER"),
  password: System.fetch_env!("POSTGRES_PASSWORD"),
  port: System.fetch_env!("POSTGRES_PORT"),
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :blog, Oban, testing: :manual

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :blog_web, BlogWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "gjAmDyL949FyBPTOk/R3bgLGu2npHO5LBPDM1tUl5m3VsfkJjKeQv2yoCDGkBS3P",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# In test we don't send emails.
config :blog, Blog.Mailer, adapter: Swoosh.Adapters.Test

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :tesla, adapter: Tesla.Mock
