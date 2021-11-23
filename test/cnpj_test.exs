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

  test "invalid when lengh is not 14" do
    refute Cnpj.valid?("223.276.500/0001-30")
    refute Cnpj.valid?("68894480000")
  end
end
