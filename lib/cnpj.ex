defmodule Cnpj do
  @moduledoc """
  This module validate, format and generate fake CNPJ
  """

  alias CpfCnpjShared, as: Shared

  @alphabet String.graphemes("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ")

  @denylist ~w[
    00000000000000
    11111111111111
    22222222222222
    33333333333333
    44444444444444
    55555555555555
    66666666666666
    77777777777777
    88888888888888
    99999999999999
  ]

  @dv1_weights [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
  @dv2_weights [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]

  @number_regex ~r/\A[0-9A-Z]{12}[0-9]{2}\z/
  @formatted_regex ~r/\A[0-9A-Z]{2}\.[0-9A-Z]{3}\.[0-9A-Z]{3}\/[0-9A-Z]{4}-[0-9]{2}\z/
  @format_regex ~r/\A([0-9A-Z]{2})([0-9A-Z]{3})([0-9A-Z]{3})([0-9A-Z]{4})([0-9A-Z]{2})\z/

  @doc """
  Normalizes a CNPJ, removing mask characters and upcasing.

  ## Examples

      iex> Cnpj.strip("12.ABC.345/01DE-35")
      "12ABC34501DE35"
      iex> Cnpj.strip("12.abc.345/01de-35")
      "12ABC34501DE35"

  """
  def strip(cnpj) do
    Shared.strip(cnpj)
  end

  @doc """
  Formats a CNPJ as `XX.XXX.XXX/XXXX-XX`.

  ## Examples

      iex> Cnpj.format("12ABC34501DE35")
      "12.ABC.345/01DE-35"

  """
  def format(cnpj) do
    normalized = Shared.strip(cnpj)

    String.replace(normalized, @format_regex, "\\1.\\2.\\3/\\4-\\5")
  end

  @doc """
  Verifies if a CNPJ is valid, including alphanumeric CNPJs.

  Pass `strict: true` to reject inputs that aren't in `XX.XXX.XXX/XXXX-XX` or
  bare 14-character form.

  ## Examples

      iex> Cnpj.valid?("37.038.201/0001-98")
      true
      iex> Cnpj.valid?("37038201000198")
      true
      iex> Cnpj.valid?("12.ABC.345/01DE-35")
      true
      iex> Cnpj.valid?("37.038.201/0001-00")
      false

  """
  def valid?(cnpj, opts \\ []) do
    upcased = cnpj |> to_string() |> String.upcase()
    normalized = Shared.strip(upcased)
    values = Shared.char_values(normalized)

    valid_strict_format?(upcased, opts) and
      valid_number_format?(normalized) and
      not_denylisted?(normalized) and
      valid_digits_verifier?(values)
  end

  @doc """
  Returns the CNPJ without its check digits.

  ## Examples

      iex> Cnpj.number_without_verifier("12.ABC.345/01DE-35")
      "12ABC34501DE"

  """
  def number_without_verifier(cnpj) do
    normalized = Shared.strip(cnpj)

    String.slice(normalized, 0, 12)
  end

  @doc """
  Generates a random alphanumeric CNPJ.

  Pass `formatted: true` to get `XX.XXX.XXX/XXXX-XX` form.

  ## Examples

      iex> Cnpj.generate() |> Cnpj.valid?()
      true

  """
  def generate(opts \\ []) do
    body = for _ <- 1..12, do: Enum.random(@alphabet)
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

  defp not_denylisted?(normalized) do
    normalized not in @denylist
  end

  defp valid_digits_verifier?(values) do
    Enum.take(values, -2) == verifier_digits(Enum.take(values, 12))
  end

  defp verifier_digits(body_values) do
    first = gen_verifier(body_values, @dv1_weights)
    second = gen_verifier(body_values ++ [first], @dv2_weights)

    [first, second]
  end

  defp gen_verifier(values, weights) do
    values
    |> Enum.zip(weights)
    |> Enum.map(fn {value, weight} -> value * weight end)
    |> Enum.sum()
    |> Shared.mod11_digit()
  end
end
