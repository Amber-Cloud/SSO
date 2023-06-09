defmodule SsoWeb.SsoController do
  use SsoWeb, :controller

  alias Sso.{User, Repo}

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new_user(conn, %{"email" => email, "password" => password}) do
    User.changeset(%User{}, %{email: email, password_hash: hash_input(password)})
    |> Repo.insert()

    text(conn, "Welcome, #{email}!")
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Repo.get_by(User, [email: email, password_hash: hash_input(password)]) do
      nil -> text(conn, "You are not registered")
      _ -> text(conn, "Welcome back, #{email}!")
    end
  end

  def register_app(conn, _params) do
    text(conn, "placeholder")
  end
  def get_access_token(conn, _params) do
    text(conn, "placeholder")
  end
  def get_user_email(conn, _params) do
    text(conn, "placeholder")
  end

  defp hash_input(input) do
    :crypto.hash(:md5, input)
    |> Base.encode16()
  end

end
