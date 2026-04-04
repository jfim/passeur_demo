import Config

config :passeur,
  port: 4000,
  admin_username: "admin",
  # password: "foo"
  admin_password_hash: "$argon2id$v=19$m=65536,t=3,p=4$RPxZvbKIKXzvyQq0vamL1A$ygcWaKKnab7oBN/MZdNT+lY5wITS4yAPcDPlKeXrrwI",
  secret_key_base: "dev_only_change_me_in_production_at_least_64_bytes_long_xxxxxxxxxxxxxxxxxxxxxxxxxx",
  server_url: "http://localhost:4000"

config :passeur, Passeur.Repo,
  username: "passeur",
  password: "postgres",
  hostname: "localhost",
  port: 5432,
  database: "passeur_demo_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true

config :boruta, Boruta.Oauth,
  issuer: "http://localhost:4000"

config :passeur_files, root: "/home/jfim/projects/passeur_demo/vault"
