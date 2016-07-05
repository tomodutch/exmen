defmodule Exmen.Discover.Middleware.Conditional do
  @moduledoc ~S"""
  Middleware to discover mutations in conditionals

  ## Examples
      iex> "if true, do: 1"
      iex> |> Code.string_to_quoted
      iex> |> Exmen.Discover.Middleware.Conditional.find_mutations
      iex> |> Enum.map(&(elem(&1, 0)))
      [:unless]
  """

  alias Exmen.Discover.Middleware

  def find_mutations(ast) do
    Middleware.run(ast, &mutate/1)
  end

  defp mutate({:if, meta, args}) do
    {:ok, {:unless, meta, args}, args}
  end
  defp mutate(_), do: nil
end
