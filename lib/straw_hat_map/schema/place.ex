defmodule StrawHat.Map.Schema.Place do
  @moduledoc false

  use StrawHat.Map.Schema
  alias StrawHat.Map.Schema.{Location, Place}

  @required_fields ~w(name owner_id)a
  @optional_fields ~w(active place_id)a

  schema "places" do
    field(:name, :string)
    field(:active, :boolean, default: true)
    field(:owner_id, :integer)
    belongs_to(:place, Place)
    belongs_to(:location, Location)
  end

  def changeset(place, place_attrs) do
    place
    |> cast(place_attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name, name: :places_name_place_id_index)
    |> assoc_constraint(:place)
  end

  def create_changeset(place, place_attrs) do
    place
    |> changeset(place_attrs)
    |> cast_assoc(:location, required: true)
  end

  def update_changeset(place, place_attrs) do
    place
    |> changeset(place_attrs)
    |> cast_assoc(:location)
  end
end
