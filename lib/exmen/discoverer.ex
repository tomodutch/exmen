defmodule Exmen.Discoverer do
  @math_operands [:+, :-, :*, :/]

  def find_mutations(ast), do: mutate(ast, [])

  defp mutate({operation, meta, args}, mutations) when operation in @math_operands do
    trans = %{
      :+ => :-,
      :- => :+,
      :* => :/,
      :/ => :*
    }

    case {Keyword.get(meta, :import), Map.get(trans, operation)} do
      {Kernel, nil}     -> mutate(args, mutations)
      {Kernel, operand} -> mutate(args, [{operand, meta, args}|mutations])
      {_, _}            -> mutate(args, mutations)
    end
  end
  defp mutate([head|tail], mutations) do
    mutate(tail, mutate(head, mutations))
  end
  defp mutate([], mutations), do: mutations
  defp mutate(n, mutations) when is_integer(n), do: mutations
end
