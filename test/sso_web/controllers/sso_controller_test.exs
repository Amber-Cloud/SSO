defmodule SsoWeb.SsoControllerTest do
  use SsoWeb.ConnCase
  alias Sso.{User, Repo}

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end

  test "GET /new_user registers a new user", %{conn: conn} do
    conn = get(conn, "/new_user", email: "test@gmail.com", password: "pwd01")
    assert text_response(conn, 200) =~ "Welcome, test@gmail.com!"
  end

  describe "GET /login" do
    setup do
      user = %User{email: "test@email.com", password_hash: hash_input("password")}
      {:ok, user} = Repo.insert(user)
      [user: user]
    end
    test "GET /login  welcomes an existing user", %{conn: conn} do
      conn = get(conn, "/login", email: "test@email.com", password: "password")
      assert text_response(conn, 200) =~ "Welcome back, test@email.com!"
    end
    test "GET /login redirects an existing user to accept page", %{conn: conn} do
      conn = get(conn, "/login", email: "test@email.com", password: "password", redirect: "3rd_party.com")
      assert html_response(conn, 200) =~ "Do you want to grant 3rd_party.com access to your email?"
    end
    test "GET /login doesn't log in a user who's not in the database", %{conn: conn} do
      conn = get(conn, "/login", email: "test1@email.com", password: "pwd01")
      assert text_response(conn, 200) =~ "You are not registered"
    end
  end

  defp hash_input(input) do
    :crypto.hash(:md5, input)
    |> Base.encode16()
  end
end
