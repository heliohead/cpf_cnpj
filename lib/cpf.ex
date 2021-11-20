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
end
