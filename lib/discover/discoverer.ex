defmodule Exmen.Discoverer do
  use GenServer

  alias Exmen.Discover.Middleware

  def start_link(middlewares) do
    GenServer.start_link(__MODULE__, middlewares, [])
  end

  def find_mutations(pid, ast) do
    GenServer.call(pid, {:find_mutations, ast})
  end

  def handle_call({:find_mutations, ast}, _from, middlewares) do
    mutations = run_middlewares(middlewares, ast)
    {:reply, mutations, middlewares}
  end

  defp run_middlewares(middlewares, ast) do
    middlewares
    |> Enum.flat_map(fn %Middleware{module: module} ->
      module.find_mutations(ast)
    end)
  end
end
