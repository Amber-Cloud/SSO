defmodule Sso.Repo do
  use Ecto.Repo,
    otp_app: :sso,
    adapter: Ecto.Adapters.Postgres
end
