defmodule Exmen.Discover.MathTest do
  use ExUnit.Case, async: true
  alias Exmen.Discover.Middleware.Math

  test "discover mutations" do
    expectations = [
      {quote(do: 1 + 1), [:-]},
      {quote(do: 1 - 1), [:+]},
      {quote(do: 1 * 1), [:/]},
      {quote(do: 1 / 1), [:*]},
      {quote(do: rem(1, 1)), [:/]},
      {quote(do: div(10, 2)), [:*]},
      {quote(do: 1 - 2 + 3), [:+, :-]}]

    mutations = Enum.flat_map(expectations, fn {ast, _} ->
      Math.find_mutations(ast)
    end) |> get_operands

    assert Enum.flat_map(expectations, &(elem(&1, 1))) == mutations
  end

  defp get_operands(mutations), do: Enum.map(mutations, &(elem(&1, 0)))
end
