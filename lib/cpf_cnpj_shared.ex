defmodule CpfCnpjShared do
  @moduledoc """
  This module share common functions
  """

  def char_values(str) do
    str
    |> String.to_charlist()
    |> Enum.map(fn char -> char - 48 end)
  end

  def strip(str) do
    str
    |> to_string()
    |> String.replace(~r/[\.\/-]/, "")
    |> String.upcase()
  end

  def mod11_digit(sum) do
    mod = rem(sum, 11)

    if mod < 2, do: 0, else: 11 - mod
  end

  def not_uniq?(list) do
    uniq_count = list |> Enum.take(12) |> Enum.uniq() |> Enum.count()

    uniq_count > 2
  end
end
