defmodule CpfCnpj do
  @moduledoc """
  Detects whether a document is a CPF or a CNPJ.
  """

  @doc """
  Detects the document type.

  Returns `Cpf`, `Cnpj`, or `nil` when the document is invalid.

  ## Examples

      iex> CpfCnpj.which("073.055.920-30")
      Cpf
      iex> CpfCnpj.which("12.ABC.345/01DE-35")
      Cnpj
      iex> CpfCnpj.which("invalid")
      nil

  """
  def which(input) do
    cond do
      Cpf.valid?(input) -> Cpf
      Cnpj.valid?(input) -> Cnpj
      true -> nil
    end
  end
end
