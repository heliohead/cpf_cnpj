defmodule Cnpj do
  @moduledoc """
  This module validate, format and generate fake CNPJ
  """

  @doc """
  Keep only numbers from string

  ## Examples

      iex> Cnpj.strip("45.055.920/0008-30")
      "45055920000830"

  """
  def strip(cnpj) do
    String.replace(cnpj, ~r/[\.\/-]/, "")
  end

  @doc """
  Verify if cnpj is valid

  ## Examples

      iex> Cnpj.valid?("37.038.201/0001-98")
      true
      iex> Cnpj.valid?("37038201000198")
      true

  """
  def valid?(cnpj) do
    list = to_list(cnpj)
    valid_size?(list) and valid_digits_verifier?(list)
  end

  defp to_list(cpf) do
    cpf |> strip() |> String.split("", trim: true) |> Enum.map(&String.to_integer/1)
  end

  defp valid_size?(list) do
    Enum.count(list) == 14
  end

  defp valid_digits_verifier?(list) do
    cnpj_digits = list |> Enum.take(-2)
    without_verifier = list |> Enum.take(12)
    first_verifier = without_verifier |> gen_verifier()
    second_verifier = (without_verifier ++ [first_verifier]) |> gen_verifier()

    cnpj_digits == [first_verifier, second_verifier]
  end

  defp gen_verifier(numbers) do
    algo =
      case Enum.count(numbers) do
        12 -> [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2, 0]
        13 -> [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
      end

    mod =
      numbers
      |> Enum.with_index()
      |> Enum.map(fn {number, index} ->
        number * Enum.at(algo, index)
      end)
      |> Enum.sum()
      |> rem(11)

    if mod < 2, do: 0, else: 11 - mod
  end
end
