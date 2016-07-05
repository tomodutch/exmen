defmodule Exmen.Discover.DiscovererTest do
  use ExUnit.Case, async: true
  doctest Exmen.Discover.Discoverer

  alias Exmen.Discover.{Discoverer, Middleware}
  alias Exmen.Discover.Middleware.{Math, Conditional}

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

  test "with multiple middleware" do
    middlewares = [
      %Middleware{module: Math},
      %Middleware{module: Conditional}
    ]

    {:ok, pid} = Discoverer.start_link(middlewares)
    ast = quote do
      if 1 + 1 do
        nil
      end
    end

    mutations = find_mutations(middlewares, ast)
    assert mutations == Discoverer.find_mutations(pid, ast)
  end

  defp find_mutations(middlewares, ast) do
    Enum.flat_map(middlewares, fn %Middleware{module: module} ->
      module.find_mutations(ast)
    end)
  end
end
