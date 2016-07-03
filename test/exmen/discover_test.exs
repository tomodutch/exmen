defmodule Exmen.DiscoverTest do
  use ExUnit.Case, async: true
  alias Exmen.Discoverer

  test "discover mutations" do
    expectations = [
      {quote(do: 1 + 1), [:-]},
      {quote(do: 1 - 1), [:+]},
      {quote(do: 1 * 1), [:/]},
      {quote(do: 1 / 1), [:*]},
      {quote(do: 1 - 2 + 3), [:+, :-]}]

    mutations = Enum.flat_map(expectations, fn {ast, _} ->
      Discoverer.find_mutations(ast)
    end) |> get_operands

    assert Enum.flat_map(expectations, &(elem(&1, 1))) == mutations
  end

  defp get_operands(mutations), do: Enum.map(mutations, &(elem(&1, 0)))
end
