defmodule Exmen.Discover.Discoverer do
  @moduledoc ~S"""
  Abstraction layer to discover mutations by provided middleware.
  """
  use GenServer

  alias Exmen.Discover.Middleware

  def start_link(middlewares) do
    GenServer.start_link(__MODULE__, middlewares, [])
  end


  @doc ~S"""
  Discover mutations in the provider `ast`

  ## Examples
      iex> alias Exmen.Discover.{Discoverer, Middleware}
      iex> alias Exmen.Discover.Middleware.Math
      iex> middlewares = [%Middleware{module: Math}]
      iex> {:ok, pid} = Discoverer.start_link(middlewares)
      iex> ast = quote(do: 1 + 1)
      iex> [{mutation, _, _}] = Discoverer.find_mutations(pid, ast)
      iex> mutation
      :-
  """
  def find_mutations(pid, ast) do
    GenServer.call(pid, {:find_mutations, ast})
  end

  def handle_call({:find_mutations, ast}, _from, middlewares) do
    mutations = run_middlewares(middlewares, ast)
    {:reply, mutations, middlewares}
  end

  defp run_middlewares(middlewares, ast) do
    middlewares
    |> Enum.map(fn %Middleware{module: module}->
      Task.async(fn ->
        module.find_mutations(ast)
       end)
    end)
    |> Enum.flat_map(&Task.await/1)
  end
end
