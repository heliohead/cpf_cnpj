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

  test "invalid when lengh is not 11" do
    refute Cpf.valid?("6889448006262")
    refute Cpf.valid?("688944800")
  end

  test "invalid if all equals" do
    refute Cpf.valid?("111.111.111-11")
    refute Cpf.valid?("44444444444")
  end

  test "invalid if on not_permited list" do
    refute Cpf.valid?("98765432100")
    refute Cpf.valid?("12345678909")
  end
end
