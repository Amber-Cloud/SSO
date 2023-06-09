defmodule Sso.Repo.Migrations.CreateCodes do
  use Ecto.Migration

  def change do
    create table(:codes) do
      add :code, :string
      add :client_id, :string

      timestamps()
    end
  end
end
