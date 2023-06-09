defmodule :"Elixir.Sso.Repo.Migrations.Add user client relationship" do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :client_id, references(:clients, column: :client_id, type: :string)
    end
  end
end
