defmodule Exmen.DiscovererTest do
  use ExUnit.Case, async: true

  alias Exmen.Discover.{Discoverer, Middleware}
  alias Exmen.Discover.Middleware.Math

  test "no middleware" do
    {:ok, pid} = Discoverer.start_link([])
    assert [] == Discoverer.find_mutations(pid, quote(do: 1 + 1))
  end

  test "with one middleware" do
    middlewares = [%Middleware{module: Math}]
    {:ok, pid} = Discoverer.start_link(middlewares)
    ast = quote(do: 1 + 1)
    mutations = Math.find_mutations(ast)
    assert mutations == Discoverer.find_mutations(pid, ast)
  end
end
