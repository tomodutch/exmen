defmodule Exmen.Discover.Middleware do
  @moduledoc ~S"""
  Abstraction layer to help travere an AST
  and interact with Mutation middleware
  """

  defstruct module: nil, config: []

  @doc ~S"""
  Start AST traversal.

  ## mutation
  The *mutate* function gets called with every node in the AST.
  This allows the middleware to manipulate nodes and change the control flow.
  The accepted return values are:
    * `{:ok, mutated_node, next_node}`
    * `{:skip, node}`
    * `any` other value gets ignored

  ## Examples
      iex> alias Exmen.Discover.Middleware
      iex> mutator = fn node ->
      iex>   case node do
      iex>     {:+, meta, args} -> {:ok, {:-, meta, args}, args}
      iex>     {:-, _, _}       -> {:skip, node}
      iex>     _                -> nil
      iex>   end
      iex> end
      iex> [mutation] = Middleware.run(quote(do: 1 - 1 + 2), mutator)
      iex> elem(mutation, 0)
      :-
  """
  def run(ast, mutate) do
    mutate(ast, [], mutate)
  end

  defp mutate(node, mutations, fun) do
    case fun.(node) do
      {:ok, new_mutation, next} ->
        mutate(next, [new_mutation|mutations], fun)
      {:skip, _} ->
        mutations
      _ ->
        do_mutate(node, mutations, fun)
    end
  end

  defp do_mutate({_, args}, mutations, fun),    do: mutate(args, mutations, fun)
  defp do_mutate({_, _, args}, mutations, fun), do: mutate(args, mutations, fun)
  defp do_mutate([head|tail], mutations, fun),  do: mutate(tail, mutate(head, mutations, fun), fun)
  defp do_mutate(_, mutations, _),              do: mutations
end
