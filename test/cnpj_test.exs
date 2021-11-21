defmodule CnpjTest do
  use ExUnit.Case
  doctest Cnpj

  test "strip" do
    assert Cpf.strip("23.276.500/0001-30") == "23276500000130"
  end
end
