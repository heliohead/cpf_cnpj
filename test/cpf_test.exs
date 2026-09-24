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

  test "invalid when not numeric" do
    refute Cpf.valid?("415.abc.500-30")
    refute Cpf.valid?("")
    refute Cpf.valid?(nil)
  end

  test "valid? with strict" do
    assert Cpf.valid?("415.276.500-30", strict: true)
    assert Cpf.valid?("41527650030", strict: true)
    refute Cpf.valid?("415....276----500-30", strict: true)
    refute Cpf.valid?("415.abc.500-30", strict: true)
  end

  test "format" do
    assert Cpf.format("07305592030") == "073.055.920-30"
    assert Cpf.format("415.276.500-30") == "415.276.500-30"
  end

  test "number_without_verifier" do
    assert Cpf.number_without_verifier("073.055.920-30") == "073055920"
    assert Cpf.number_without_verifier("41527650030") == "415276500"
  end

  test "generate" do
    assert Cpf.valid?(Cpf.generate())
    assert Cpf.valid?(Cpf.generate(formatted: true))
  end

  test "generate returns numbers" do
    assert Cpf.generate() =~ ~r/\A[0-9]{11}\z/
  end
end
