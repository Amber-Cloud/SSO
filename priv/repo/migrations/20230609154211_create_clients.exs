defmodule Sso.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    create table(:clients) do
      add :client_id, :string
      add :client_secret, :string
      add :redirect_url, :string

      timestamps()
    end
  end
end
