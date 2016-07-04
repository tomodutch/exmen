defmodule Exmen.Discover.Middleware do
  defstruct module: nil, config: []

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
