defmodule Sso.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password_hash, :string

    belongs_to :client, Sso.Client
    timestamps()
  end

  @doc false
  def changeset(user_struct, attrs \\ %{}) do
    user_struct
    |> cast(attrs, [:email, :password_hash])
    |> validate_required([:email, :password_hash])
  end
end
