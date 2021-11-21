defmodule Cnpj do
  @moduledoc """
  This module validate, format and generate fake CPF
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
end
