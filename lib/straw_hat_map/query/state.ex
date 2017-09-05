defmodule StrawHat.Map.Query.StateQuery do
  @moduledoc false

  import Ecto.Query, only: [from: 2]

  def by_ids(query, ids) do
    from state in query,
      where: state.id in ^ids
  end

  def by_countries(query, country_ids) do
    from state in query,
      where: state.country_id in ^country_ids
  end
end