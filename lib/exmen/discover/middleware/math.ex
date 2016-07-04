defmodule Exmen.Discover.Middleware.Math do
  @moduledoc """
  Mutator of Math operands

  ## Examples
      iex> "(1 + 2 - 3) * 4 / 5"
      iex> |> Code.string_to_quoted
      iex> |> Exmen.Discover.Middleware.Math.find_mutations
      iex> |> Enum.map(&(elem(&1, 0)))
      [:-, :+, :/, :*]

      iex> "rem(10, 2)"
      iex> |> Code.string_to_quoted
      iex> |> Exmen.Discover.Middleware.Math.find_mutations
      iex> |> Enum.map(&(elem(&1, 0)))
      [:/]
  """
  alias Exmen.Discover.Middleware

  @trans %{
    :+ => :-,
    :- => :+,
    :* => :/,
    :/ => :*,
    :rem => :/,
    :div => :*
  }

  @doc ~S"""
  Find all possible mutations in `ast`
  """
  def find_mutations(ast) do
    Middleware.run(ast, &mutate/1)
  end

  defp mutate({:&, _meta, [{:/, _, _}|_]} = node) do
    # skip short function notation
    {:skip, node}
  end
  defp mutate({operation, meta, args}) do
    case Map.get(@trans, operation) do
      nil      -> nil
      operator -> {:ok, {operator, meta, args}, args}
    end
  end
  defp mutate(_), do: nil
end
