defmodule Exmen.Discover.Middleware.Math do
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
  def find_mutations(ast), do: mutate(ast, [])

  def mutate({operation, meta, args}, mutations) when operation in @math_operands do
    trans = %{
      :+ => :-,
      :- => :+,
      :* => :/,
      :/ => :*,
      :rem => :/,
      :div => :*
    }

    case {Keyword.get(meta, :import), Map.get(trans, operation)} do
      {Kernel, nil}     -> mutate(args, mutations)
      {Kernel, operand} -> mutate(args, [{operand, meta, args}|mutations])
      {_, _}            -> mutate(args, mutations)
    end
  end

  def mutate({_, args}, mutations),    do: mutate(args, mutations)
  def mutate({_, _, args}, mutations), do: mutate(args, mutations)
  def mutate([head|tail], mutations),  do: mutate(tail, mutate(head, mutations))
  def mutate([], mutations),           do: mutations
  def mutate(_, mutations),            do: mutations
end
