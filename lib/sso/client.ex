defmodule Sso.Client do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clients" do
    field :client_id, :string
    field :client_secret, :string
    field :redirect_url, :string

    has_many :users, Sso.User, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, [:client_id, :client_secret, :redirect_url])
    |> validate_required([:client_id, :client_secret, :redirect_url])
  end
end
