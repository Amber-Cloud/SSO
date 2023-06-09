defmodule SsoWeb.SsoControllerTest do
  use SsoWeb.ConnCase
  alias Sso.{User, Code, AccessToken, Repo}

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end

  test "GET /new_user registers a new user", %{conn: conn} do
    conn = get(conn, "/new_user", email: "test@gmail.com", password: "pwd01")
    assert text_response(conn, 200) =~ "Welcome, test@gmail.com!"
  end

  #  describe "GET /login_submit" do
  #    setup do
  #      user = %User{email: "test@email.com", password_hash: hash_input("password")}
  #      {:ok, user} = Repo.insert(user)
  #      [user: user]
  #    end
  ##    test "GET /login  welcomes an existing user", %{conn: conn} do
  ##      conn = get(conn, "/login", email: "test@email.com", password: "password")
  ##      assert text_response(conn, 200) =~ "Welcome back, test@email.com!"
  ##    end
  # end
  test "GET /login_form renders an empty login form", %{conn: conn} do
    conn =
      get(conn, "/login_form",
        client_id: "client_id",
        redirect_url: "3rd_party.com/callback",
        state: ""
      )

    assert html_response(conn, 200) =~ "Please log in"
  end

  test "POST /login_submit redirects an existing user to accept page", %{conn: conn} do
    user = %User{email: "test@email.com", password_hash: hash_input("password")}
    {:ok, user} = Repo.insert(user)

    conn =
      post(conn, "/login_submit",
        email: "test@email.com",
        password: "password",
        redirect_url: "3rd_party.com/callback",
        state: "state",
        client_id: "client_id"
      )

    assert redirected_to(conn, 302) =~ "/accept_form"
  end

  test "POST /login_submit doesn't log in a user who's not in the database", %{conn: conn} do
    conn =
      post(conn, "/login_submit",
        email: "test1@email.com",
        password: "pwd01",
        redirect_url: "3rd_party.com/callback",
        state: "state",
        client_id: "client_id"
      )

    assert text_response(conn, 200) =~ "You are not registered"
  end

  test "GET /register_app registers a new client", %{conn: conn} do
    conn =
      get(conn, "/register_app",
        redirect_url: "3rd_party.com/callback",
        client_name: "3rd_party.com"
      )

    assert text_response(conn, 200) =~ "Credentials saved for 3rd_party.com"
  end

  test "GET /accept_form renders an empty accept form", %{conn: conn} do
    conn =
      get(conn, "/accept_form",
        redirect_url: "3rd_party.com/callback",
        state: "",
        client_id: "client_id"
      )

    assert html_response(conn, 200) =~ "Do you want to grant access to your email?"
  end

  test "POST /accept_and_redirect redirects to the 3rd party redirect url", %{conn: conn} do
    conn =
      post(conn, "/accept_and_redirect",
        redirect_url: "https://3rd_party.com/callback",
        state: "",
        client_id: "client_id"
      )

    assert redirected_to(conn, 302) =~ "3rd_party.com/callback"
  end

  test "POST /get_access_token returns code 401 if unauthorized", %{conn: conn} do
    conn =
      post(conn, "/get_access_token",
        code: "code",
        redirect_url: "https://3rd_party.com/callback",
        client_id: "client_id"
      )

    assert json_response(conn, 401)
  end

  test "POST /get_access_token returns json with access token if authorized", %{conn: conn} do
    code = %Code{client_id: "client_id", code: "code"}
    {:ok, code} = Repo.insert(code)

    conn =
      post(conn, "/get_access_token",
        code: "code",
        redirect_url: "https://3rd_party.com/callback",
        client_id: "client_id"
      )

    assert %{"access_token" => _} = json_response(conn, 200)
  end

  defp hash_input(input) do
    :crypto.hash(:md5, input)
    |> Base.encode16()
  end
end
