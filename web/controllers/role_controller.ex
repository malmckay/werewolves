defmodule Werewolves.RoleController do
  use Werewolves.Web, :controller

  alias Werewolves.Role

  plug :scrub_params, "role" when action in [:create, :update]

  def index(conn, _params) do
    roles = Repo.all(Role)
    player_count = length(Repo.all(Werewolves.Player))
    assigned_roles = role_count
    render(conn, "index.html", roles: roles, player_count: player_count, assigned_roles: assigned_roles)
  end

  def new(conn, _params) do
    changeset = Role.changeset(%Role{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"role" => role_params}) do
    changeset = Role.changeset(%Role{}, role_params)

    case Repo.insert(changeset) do
      {:ok, _role} ->
        conn
        |> put_flash(:info, "Role created successfully.")
        |> redirect(to: role_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    role = Repo.get!(Role, id)
    render(conn, "show.html", role: role)
  end

  def edit(conn, %{"id" => id}) do
    role = Repo.get!(Role, id)
    player_count = player_count
    assigned_roles = role_count
    changeset = Role.changeset(role)
    render(conn, "edit.html", role: role, player_count: player_count, assigned_roles: assigned_roles, changeset: changeset)
  end

  def update(conn, %{"id" => id, "role" => role_params}) do
    role = Repo.get!(Role, id)
    changeset = Role.changeset(role, role_params)

    case Repo.update(changeset) do
      {:ok, role} ->
        conn
        |> put_flash(:info, "Role updated successfully.")
        |> redirect(to: role_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", role: role, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    role = Repo.get!(Role, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(role)

    conn
    |> put_flash(:info, "Role deleted successfully.")
    |> redirect(to: role_path(conn, :index))
  end
  

  def role_count do
    roles = Repo.all(Werewolves.Role)
    Enum.reduce(roles, 0, fn(x, acc) -> x.count + acc end)
  end

  def player_count do 
    players = Repo.all(Werewolves.Player)
    length(players)
  end
end
