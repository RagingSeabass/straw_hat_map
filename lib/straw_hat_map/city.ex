defmodule StrawHat.Map.City do
  import Ecto.Query, only: [from: 2]

  alias StrawHat.Map.Repo
  alias StrawHat.Map.Schema.City

  def list_cities(params), do: Repo.paginate(City, params)

  def create_city(params) do
    %City{}
    |> City.changeset(params)
    |> Repo.insert()
  end

  def update_city(%City{} = city, params) do
    city
    |> City.changeset(params)
    |> Repo.update()
  end
  def update_city(city, params) do
    with {:ok, city} <- find_city(city),
      do: update_city(city, params)
  end

  def destroy_city(%City{} = city),
    do: Repo.delete(city)
  def destroy_city(city) do
    with {:ok, city} <- find_city(city),
      do: destroy_city(city)
  end

  def find_city(id) do
    case get_city(id) do
      nil -> {:error, {:not_found, "City #{id} not found"}}
      city -> {:ok, city}
    end
  end

  def get_city(id),
    do: Repo.get(City, id)

  def city_by_ids(city_ids) do
    query =
      from ci in City,
      where: ci.id in ^city_ids
    Repo.all(query)
  end
end
