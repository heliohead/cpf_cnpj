defmodule Cpf do
  @moduledoc """
  This module validate, format and generate fake CPF
  """

  alias CpfCnpjShared, as: Shared

  @alphabet String.graphemes("0123456789")

  @not_permited ["12345678909", "01234567890", "98765432100"]

  @number_regex ~r/\A[0-9]{11}\z/
  @formatted_regex ~r/\A[0-9]{3}\.[0-9]{3}\.[0-9]{3}-[0-9]{2}\z/
  @format_regex ~r/\A([0-9]{3})([0-9]{3})([0-9]{3})([0-9]{2})\z/

  @doc """
  Normalizes a CPF, removing mask characters.

  ## Examples

      iex> Cpf.strip("073.055.920-30")
      "07305592030"

  """
  def strip(cpf) do
    Shared.strip(cpf)
  end

  @doc """
  Formats a CPF as `XXX.XXX.XXX-XX`.

  ## Examples

      iex> Cpf.format("07305592030")
      "073.055.920-30"

  """
  def format(cpf) do
    normalized = Shared.strip(cpf)

    String.replace(normalized, @format_regex, "\\1.\\2.\\3-\\4")
  end

  @doc """
  Verifies if a CPF is valid.

  Pass `strict: true` to reject inputs that aren't in `XXX.XXX.XXX-XX` or
  bare 11-character form.

  ## Examples

      iex> Cpf.valid?("073.055.920-30")
      true
      iex> Cpf.valid?("11111111111")
      false

  """
  def valid?(cpf, opts \\ []) do
    upcased = cpf |> to_string() |> String.upcase()
    normalized = Shared.strip(upcased)
    values = Shared.char_values(normalized)

    valid_strict_format?(upcased, opts) and
      valid_number_format?(normalized) and
      not_on_not_permited?(normalized) and
      Shared.not_uniq?(values) and
      valid_digits_verifier?(values)
  end

  @doc """
  Returns the CPF without its check digits.

  ## Examples

      iex> Cpf.number_without_verifier("073.055.920-30")
      "073055920"

  """
  def number_without_verifier(cpf) do
    normalized = Shared.strip(cpf)

    String.slice(normalized, 0, 9)
  end

  @doc """
  Generates a random CPF.

  Pass `formatted: true` to get `XXX.XXX.XXX-XX` form.

  ## Examples

      iex> Cpf.generate() |> Cpf.valid?()
      true

  """
  def generate(opts \\ []) do
    body = for _ <- 1..9, do: Enum.random(@alphabet)
    verifiers = body |> Enum.join() |> Shared.char_values() |> verifier_digits()
    number = Enum.join(body ++ Enum.map(verifiers, &Integer.to_string/1))

    if Keyword.get(opts, :formatted, false), do: format(number), else: number
  end

  defp valid_strict_format?(upcased, opts) do
    not Keyword.get(opts, :strict, false) or valid_input_format?(upcased)
  end

  defp valid_input_format?(upcased) do
    Regex.match?(@formatted_regex, upcased) or Regex.match?(@number_regex, upcased)
  end

  defp valid_number_format?(normalized) do
    Regex.match?(@number_regex, normalized)
  end

  defp not_on_not_permited?(normalized) do
    normalized not in @not_permited
  end

  defp valid_digits_verifier?(values) do
    Enum.take(values, -2) == verifier_digits(Enum.take(values, 9))
  end

  defp verifier_digits(body_values) do
    first = gen_verifier(body_values)
    second = gen_verifier(body_values ++ [first])

    [first, second]
  end

  defp gen_verifier(values) do
    modulus = Enum.count(values) + 1

    values
    |> Enum.with_index()
    |> Enum.map(fn {value, index} -> value * (modulus - index) end)
    |> Enum.sum()
    |> Shared.mod11_digit()
  end
end
