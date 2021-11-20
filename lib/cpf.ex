defmodule Cpf do
  @moduledoc """
  This module validate, format and generate fake CPF
  """
  @not_permited ["12345678909", "01234567890", "98765432100"]

  @doc """
  Keep only numbers from string

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
      iex> Cpf.valid?("11111111111")
      false

  """
  def valid?(cpf) do
    list = to_list(cpf)

    not_on_not_permited?(list) and
      uniq?(list) and
      valid_size?(list) and
      valid_digits_verifier?(list)
  end

  defp not_on_not_permited?(list) do
    !Enum.member?(@not_permited, Enum.join(list))
  end

  defp uniq?(list) do
    list |> Enum.uniq() |> Enum.count() |> Kernel.>(2)
  end

  defp valid_size?(list) do
    Enum.count(list) == 11
  end

  defp valid_digits_verifier?(list) do
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
