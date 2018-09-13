defmodule WishlisterWeb.AuthController do
  use WishlisterWeb, :controller

  plug Ueberauth

  alias Wishlister.User
  alias Wishlister.Repo

  def callback(%{ assigns: %{ ueberauth_auth: auth } } = conn,
                %{"provider" => provider}) do
    user_params = build_user_params(auth, provider)

    changeset = User.changeset(%User{}, user_params)

    signin(conn, changeset)
  end

  defp build_user_params(auth, provider) do
    %{
      token: auth.credentials.token,
      email: auth.info.email,
      provider: provider,
      name: auth.info.first_name,
      avatar: build_user_avatar_url(auth.info.image),
      provider_uid: auth.uid
    }
  end

  defp build_user_avatar_url(%{ "prefix" => prefix, "suffix" => suffix } ) do
    "#{prefix}52x52#{suffix}"
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: list_path(conn, :index))
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      { :ok, user } ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: list_path(conn, :list))
      { :error, _reason } ->
        conn
        |> put_flash(:error, "Error sign in")
        |> redirect(to: list_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, provider_uid: changeset.changes.provider_uid) do
      nil ->
        Repo.insert(changeset)
      user ->
        { :ok, user }
    end
  end
end
