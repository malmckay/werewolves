defmodule Werewolves.PlayerController do
  use Werewolves.Web, :controller

  alias Werewolves.Player

  plug :scrub_params, "player" when action in [:create, :update]

  def index(conn, _params) do
    players = Repo.all(Player)
    player_count = length(players)
    assigned_roles = role_count
    render(conn, "index.html", players: players, player_count: player_count, assigned_roles: assigned_roles)
  end

  def new(conn, _params) do
    changeset = Player.changeset(%Player{})
    player_count = player_count
    assigned_roles = role_count
    render(conn, "new.html", changeset: changeset, player_count: player_count, assigned_roles: assigned_roles)
  end

  def create(conn, %{"player" => player_params}) do
    changeset = Player.changeset(%Player{}, player_params)

    case Repo.insert(changeset) do
      {:ok, _player} ->
        conn
        |> put_flash(:info, "Player created successfully.")
        |> redirect(to: player_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    player = Repo.get!(Player, id)
    assigned_roles = role_count
    render(conn, "show.html", player: player, assigned_roles: assigned_roles)
  end

  def edit(conn, %{"id" => id}) do
    player = Repo.get!(Player, id)
    player_count = player_count
    assigned_roles = role_count
    changeset = Player.changeset(player)
    render(conn, "edit.html", player: player, changeset: changeset, player_count: player_count, assigned_roles: assigned_roles)
  end

  def update(conn, %{"id" => id, "player" => player_params}) do
    player = Repo.get!(Player, id)
    changeset = Player.changeset(player, player_params)
    player_count = player_count
    assigned_roles = role_count

    case Repo.update(changeset) do
      {:ok, player} ->
        conn
        |> put_flash(:info, "Player updated successfully.")
        |> redirect(to: player_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", player: player, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    player = Repo.get!(Player, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(player)

    conn
    |> put_flash(:info, "Player deleted successfully.")
    |> redirect(to: player_path(conn, :index))
  end


  def role_count do
    roles = Repo.all(Werewolves.Role)
    Enum.reduce(roles, 0, fn(x, acc) -> x.count + acc end)
  end

  def player_count do 
    players = Repo.all(Player)
    length(players)
  end
end
