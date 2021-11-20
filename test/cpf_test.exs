defmodule CpfTest do
  use ExUnit.Case
  doctest Cpf

  test "strip" do
    assert Cpf.strip("415.276.500-30") == "41527650030"
  end

  test "valid?" do
    assert Cpf.valid?("415.276.500-30")
    assert Cpf.valid?("68894480062")
    refute Cpf.valid?("415.276.500-00")
    refute Cpf.valid?("41527650000")
  end
end
