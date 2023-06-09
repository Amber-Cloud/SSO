defmodule Sso.Repo.Migrations.CreateAccessTokens do
  use Ecto.Migration

  def change do
    create table(:access_tokens) do
      add :access_token, :string
      add :client_id, :string

      timestamps()
    end
  end
end
