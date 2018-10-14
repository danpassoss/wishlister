defmodule Wishlister.Accounts do

  alias Wishlister.{Repo, Accounts.User}

  def sign_in_user(user, provider) do
    %User{}
    |> User.changeset(build_user_params(user, provider))
    |> insert_or_update_user
  end

  defp build_user_params(user, provider) do
    %{
      token: user.credentials.token,
      email: user.info.email,
      provider: provider,
      name: user.info.first_name,
      avatar: build_user_avatar_url(user.info.image),
      provider_uid: user.uid
    }
  end

  defp build_user_avatar_url(%{ "prefix" => prefix, "suffix" => suffix } ) do
    "#{prefix}52x52#{suffix}"
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
