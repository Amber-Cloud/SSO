defmodule SsoWeb.SsoController do
  use SsoWeb, :controller

  alias Sso.{Repo, User, Code, AccessToken, Client}

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new_user(conn, %{"email" => email, "password" => password}) do
    User.changeset(%User{}, %{email: email, password_hash: hash_input(password)})
    |> Repo.insert()

    text(conn, "Welcome, #{email}!")
  end

  def login_form(conn, %{
        "client_id" => client_id,
        "redirect_url" => redirect_url,
        "state" => state
      }) do
    render(conn, "login.html", client_id: client_id, redirect_url: redirect_url, state: state)
  end

  def login_submit(conn, %{
        "email" => email,
        "password" => password,
        "redirect_url" => redirect_url,
        "state" => state,
        "client_id" => client_id
      }) do
    case Repo.get_by(User, email: email, password_hash: hash_input(password)) |> IO.inspect() do
      nil ->
        text(conn, "You are not registered")

      user ->
        User.changeset(user, %{client_id: client_id})
        |> Repo.update!()

        redirect(conn,
          to: Routes.sso_path(conn, :accept_form, state: state, redirect_url: redirect_url)
        )
    end
  end

  def register_app(conn, %{"redirect_url" => redirect_url, "client_name" => client_name}) do
    Client.changeset(%Client{}, %{
      client_id: Ecto.UUID.generate(),
      client_secret: Ecto.UUID.generate(),
      redirect_url: redirect_url
    })
    |> Repo.insert()

    text(conn, "Credentials saved for #{client_name}")
  end

  def accept_form(conn, %{
        "redirect_url" => redirect_url,
        "state" => state,
        "client_id" => client_id
      }) do
    render(conn, "accept.html", redirect_url: redirect_url, state: state, client_id: client_id)
  end

  def accept_and_redirect(conn, %{
        "redirect_url" => redirect_url,
        "state" => state,
        "client_id" => client_id
      }) do
    code = Ecto.UUID.generate()

    Code.changeset(%Code{}, %{client_id: client_id, code: code})
    |> Repo.insert()

    redirect(conn, external: redirect_url, code: code)
  end

  def get_access_token(conn, %{
        "code" => code,
        "redirect_url" => redirect_url,
        "client_id" => client_id
      }) do
    case Repo.get_by(Code, code: code) do
      nil ->
        conn |> Plug.Conn.put_status(401) |> json(%{status: :unauthorized})

      code ->
        Repo.delete!(code)
        access_token = Ecto.UUID.generate()

        AccessToken.changeset(%AccessToken{}, %{client_id: client_id, access_token: access_token})
        |> Repo.insert()

        json(conn, %{access_token: access_token})
    end
  end

  #  def get_user_email(conn, %{"access_token" => "Bearer "<>access_token}) do
  #    case Repo.get_by(AccessToken, access_token: access_token) do
  #      nil ->
  #        conn |> Plug.Conn.put_status(401) |> json(%{status: :unauthorized})
  #      access_token ->
  #        AccessToken.changeset(%AccessToken{}, %{client_id: client_id, access_token: access_token})
  #        |> Repo.insert()
  #
  #        json(conn, %{access_token: access_token})
  #    end
  #  end

  defp hash_input(input) do
    :crypto.hash(:md5, input)
    |> Base.encode16()
  end
end
