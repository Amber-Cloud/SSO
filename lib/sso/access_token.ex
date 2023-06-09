defmodule Sso.AccessToken do
  use Ecto.Schema
  import Ecto.Changeset

  schema "access_tokens" do
    field :access_token, :string
    field :client_id, :string

    timestamps()
  end

  @doc false
  def changeset(access_token, attrs) do
    access_token
    |> cast(attrs, [:access_token, :client_id])
    |> validate_required([:access_token, :client_id])
  end
end
