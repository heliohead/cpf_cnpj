defmodule CpfCnpjTest do
  use ExUnit.Case
  doctest CpfCnpj

  test "which returns Cpf for a cpf" do
    assert CpfCnpj.which("073.055.920-30") == Cpf
    assert CpfCnpj.which("07305592030") == Cpf
  end

  test "which returns Cnpj for a numeric cnpj" do
    assert CpfCnpj.which("54.550.752/0001-55") == Cnpj
    assert CpfCnpj.which("54550752000155") == Cnpj
  end

  test "which returns Cnpj for an alphanumeric cnpj" do
    assert CpfCnpj.which("12.ABC.345/01DE-35") == Cnpj
    assert CpfCnpj.which("12.abc.345/01de-35") == Cnpj
  end

  test "which returns nil for invalid documents" do
    assert CpfCnpj.which("invalid") == nil
    assert CpfCnpj.which("") == nil
    assert CpfCnpj.which(nil) == nil
    assert CpfCnpj.which("00000000000000") == nil
  end
end
