defmodule PasseurDemo.Release do
  @moduledoc """
  Database setup tasks for releases.

  Automatically creates the database (if needed) and runs all migrations
  from both the passeur and boruta dependencies.
  """

  @app :passeur_demo

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, fn repo ->
        for migration_dir <- migration_dirs() do
          Ecto.Migrator.run(repo, migration_dir, :up, all: true)
        end
      end)
    end
  end

  def create_and_migrate do
    load_app()

    for repo <- repos() do
      case repo.__adapter__().storage_up(repo.config()) do
        :ok -> :ok
        {:error, :already_up} -> :ok
        {:error, reason} -> raise "Could not create database: #{inspect(reason)}"
      end
    end

    migrate()
  end

  defp repos do
    [Passeur.Repo]
  end

  defp migration_dirs do
    [
      Application.app_dir(:passeur, "priv/repo/migrations")
    ]
  end

  defp load_app do
    Application.ensure_all_started(:ssl)
    Application.load(@app)
  end
end
