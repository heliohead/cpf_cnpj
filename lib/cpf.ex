defmodule Cpf do
  @moduledoc """
  This module validate, format and generate fake CPF
  """

  @doc """
  Keep only number from string

  ## Examples

      iex> Cpf.strip("073.055.920-30")
      "07305592030"

  """
  def strip(cpf) do
    String.replace(cpf, ~r/[\.\/-]/, "")
  end

  @doc """
  Verify if cpf is valid

  ## Examples

      iex> Cpf.valid?("073.055.920-30")
      true

  """
  def valid?(cpf) do
    digits_verifier?(cpf)
  end

  defp digits_verifier?(cpf) do
    list = cpf |> to_list()
    cpf_digits = list |> Enum.take(-2)
    without_verifier = list |> Enum.take(9)
    first_verifier = without_verifier |> gen_verifier()
    second_verifier = (without_verifier ++ [first_verifier]) |> gen_verifier()

    cpf_digits == [first_verifier, second_verifier]
  end

  defp to_list(cpf) do
    cpf |> strip() |> String.split("", trim: true) |> Enum.map(&String.to_integer/1)
  end

  defp gen_verifier(numbers) do
    modulus = Enum.count(numbers) + 1

    mod =
      numbers
      |> Enum.with_index()
      |> Enum.map(fn {number, index} ->
        number * (modulus - index)
      end)
      |> Enum.sum()
      |> rem(11)

    if mod < 2, do: 0, else: 11 - mod
  end
end
