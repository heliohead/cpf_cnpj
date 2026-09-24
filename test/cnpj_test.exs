defmodule CnpjTest do
  use ExUnit.Case
  doctest Cnpj

  test "strip" do
    assert Cnpj.strip("23.276.500/0001-30") == "23276500000130"
  end

  test "strip alphanumeric" do
    assert Cnpj.strip("12.ABC.345/01DE-35") == "12ABC34501DE35"
    assert Cnpj.strip("12.abc.345/01de-35") == "12ABC34501DE35"
  end

  test "valid?" do
    assert Cnpj.valid?("42.205.695/0001-98")
    refute Cnpj.valid?("42.205.695/0001-65")
  end

  test "valid alphanumeric" do
    assert Cnpj.valid?("12.ABC.345/01DE-35")
    assert Cnpj.valid?("12ABC34501DE35")
    assert Cnpj.valid?("12.abc.345/01de-35")
  end

  test "valid alphanumeric with letters on ordem" do
    assert Cnpj.valid?("12.345.678/000A-08")
    assert Cnpj.valid?("AA345678/000A-29")
    assert Cnpj.valid?("AA345678/0003-86")
  end

  test "invalid alphanumeric with wrong verifier digits" do
    refute Cnpj.valid?("12.ABC.345/01DE-36")
    refute Cnpj.valid?("12ABC34501DE36")
  end

  test "invalid when verifier digits are not numbers" do
    refute Cnpj.valid?("12ABC34501DEAB")
  end

  test "invalid when lengh is not 14" do
    refute Cnpj.valid?("223.276.500/0001-30")
    refute Cnpj.valid?("68894480000")
  end

  test "invalid if all equals" do
    refute Cnpj.valid?("11.111.111/1111-11")
    refute Cnpj.valid?("5555555555555")
  end

  test "invalid if on denylist" do
    refute Cnpj.valid?("00000000000000")
    refute Cnpj.valid?("11111111111111")
    refute Cnpj.valid?("99.999.999/9999-99")
    assert Cnpj.valid?("11111111111180")
  end

  test "invalid when not alphanumeric" do
    refute Cnpj.valid?("aa.bb.ccc/dddd-ee")
    refute Cnpj.valid?("54550[752#0001..$55")
    refute Cnpj.valid?("")
    refute Cnpj.valid?(nil)
  end

  test "valid? with strict" do
    assert Cnpj.valid?("54.550.752/0001-55", strict: true)
    assert Cnpj.valid?("54550752000155", strict: true)
    assert Cnpj.valid?("12.ABC.345/01DE-35", strict: true)
    assert Cnpj.valid?("12ABC34501DE35", strict: true)
    refute Cnpj.valid?("54....550....752///0001---55", strict: true)
    refute Cnpj.valid?("aa.bb.ccc/dddd-ee", strict: true)
  end

  test "format" do
    assert Cnpj.format("12ABC34501DE35") == "12.ABC.345/01DE-35"
    assert Cnpj.format("45055920000830") == "45.055.920/0008-30"
    assert Cnpj.format("12.abc.345/01de-35") == "12.ABC.345/01DE-35"
  end

  test "number_without_verifier" do
    assert Cnpj.number_without_verifier("12.ABC.345/01DE-35") == "12ABC34501DE"
    assert Cnpj.number_without_verifier("54550752000155") == "545507520001"
  end

  test "generate" do
    assert Cnpj.valid?(Cnpj.generate())
    assert Cnpj.valid?(Cnpj.generate(formatted: true))
  end

  test "generate returns alphanumeric" do
    assert Cnpj.generate() =~ ~r/\A[0-9A-Z]{12}[0-9]{2}\z/
  end
end
