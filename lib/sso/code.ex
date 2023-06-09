defmodule Sso.Code do
  use Ecto.Schema
  import Ecto.Changeset

  schema "codes" do
    field :client_id, :string
    field :code, :string

    timestamps()
  end

  @doc false
  def changeset(code, attrs) do
    code
    |> cast(attrs, [:code, :client_id])
    |> validate_required([:code, :client_id])
  end
end
