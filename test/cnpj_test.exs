defmodule CnpjTest do
  use ExUnit.Case
  doctest Cnpj

  test "strip" do
    assert Cnpj.strip("23.276.500/0001-30") == "23276500000130"
  end

  test "valid?" do
    assert Cnpj.valid?("42.205.695/0001-98")
    refute Cnpj.valid?("42.205.695/0001-65")
  end
end
