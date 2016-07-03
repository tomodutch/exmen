defmodule Exmen.Discover.Middleware.Math do
  alias Exmen.Discover.Middleware

  @moduledoc """
  Mutator of Math operands

  ## Examples
      iex> ast = quote do: 1 + 1
      iex> [mutation|_] = Exmen.Discover.Middleware.Math.find_mutations(ast)
      iex> elem(mutation, 0)
      :-
  """

  @math_operands [:+, :-, :*, :/, :rem, :div]

  @doc ~S"""
  Find all possible mutations in `ast`
  """
  def find_mutations(ast) do
    Middleware.run(ast, &mutate/1)
  end

  def mutate({operation, meta, args}) when operation in @math_operands do
    trans = %{
      :+ => :-,
      :- => :+,
      :* => :/,
      :/ => :*,
      :rem => :/,
      :div => :*
    }

    case {Keyword.get(meta, :import), Map.get(trans, operation)} do
      {Kernel, nil}     -> nil
      {Kernel, operand} -> {:ok, {operand, meta, args}, args}
      {_, _}            -> nil
    end
  end

  def mutate(_), do: nil
end
