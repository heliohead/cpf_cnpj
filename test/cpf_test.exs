defmodule CPFTest do
  use ExUnit.Case
  doctest Cpf

  test "strip" do
    assert Cpf.strip("415.276.500-30") == "41527650030"
  end
end
