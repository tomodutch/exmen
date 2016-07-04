defmodule Exmen.Discover.Middleware.ConditionalTest do
  use ExUnit.Case, async: true
  alias Exmen.Discover.Middleware.Conditional
  doctest Conditional

  test "no confitionals" do
    assert [] == Conditional.find_mutations(quote(do: 1 + 1))
  end

  test "single if" do
    ast = quote do
      if 1 + 1 do
      end
    end

    [{_, meta, args} = mutation] = Conditional.find_mutations(ast)
    assert {:unless, meta, args} == mutation
  end
end
