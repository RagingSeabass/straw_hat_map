defmodule StrawHat.Map.AddressesTest do
  use StrawHat.Map.Test.DataCase, async: true
  alias StrawHat.Map.{Addresses, Address, Countries}

  describe "find_address/1" do
    test "with valid id should returns the found address" do
      address = insert(:address)
      assert {:ok, _address} = Addresses.find_address(address.id)
    end

    test "with invalid id shouldn't return any address" do
      assert {:error, _reason} = Ecto.UUID.generate() |> Addresses.find_address()
    end
  end

  test "get_addresses/1 returns a pagination of addresses" do
    insert_list(4, :address)
    address_page = Addresses.get_addresses(%{page: 2, page_size: 2})

    assert length(address_page.entries) == 2
  end

  test "create_address/1 with valid inputs creates an address" do
    params = params_with_assocs(:address)

    assert {:ok, _address} = Addresses.create_address(params)
  end

  test "update_address/2 with valid inputs updates the address" do
    new_city = insert(:city)
    address = insert(:address)

    {:ok, address} =
      Addresses.update_address(address, %{
        line_two: "PO BOX 123",
        city_id: new_city.id
      })

    assert address.line_two == "PO BOX 123"
  end

  test "destroy_address/1 with a found address destroys the address" do
    address = insert(:address)

    assert {:ok, _} = Addresses.destroy_address(address)
  end

  test "get_addresses_by_ids/1 with a list of IDs returns the relative addresses" do
    available_addresses = insert_list(3, :address)

    ids =
      available_addresses
      |> Enum.take(2)
      |> Enum.map(fn address -> address.id end)

    addresses = Addresses.get_addresses_by_ids(ids)

    assert List.first(addresses).id == List.first(ids)
    assert List.last(addresses).id == List.last(ids)
  end

  describe "postal code validations" do
    test "with country postal code value" do
      city = insert(:city)

      {:ok, _country} =
        Countries.update_country(city.state.country, %{
          postal_code_rule: "/\\d/"
        })

      params = params_with_assocs(:address, %{postal_code: "pepeHands"})
      assert {:ok, _address} = Addresses.create_address(params)
    end

    test "with nil postal code value" do
      city = insert(:city)

      {:ok, _country} =
        Countries.update_country(city.state.country, %{
          postal_code_rule: "/\\d/"
        })

      params = params_with_assocs(:address, %{postal_code: "pepeHands"})
      assert {:ok, _address} = Addresses.create_address(params)
    end
  end

  test "Address.get_postal_code_rule/1" do
    assert Address.default_postal_code_rule() == Address.get_postal_code_rule([])
    assert 123 == Address.get_postal_code_rule(postal_code_rule: 123)
  end
end