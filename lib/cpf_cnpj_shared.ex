defmodule CpfCnpjShared do
  @moduledoc """
  This module share common functions
  """

  def to_list_on_int(str) do
    str |> strip() |> String.split("", trim: true) |> Enum.map(&String.to_integer/1)
  end

  def strip(cnpj) do
    String.replace(cnpj, ~r/[\.\/-]/, "")
  end

  def not_uniq?(list) do
    list |> Enum.uniq() |> Enum.count() |> Kernel.>(2)
  end
end
