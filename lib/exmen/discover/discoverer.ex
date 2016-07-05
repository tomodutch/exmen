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
  Discover mutations in the quoted `ast`

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
    run_middlewares(get_middlewares(pid), ast)
  end

  @doc ~S"""
  Discover mutations from a list of file paths

  ## Examples
      iex> alias Exmen.Discover.{Discoverer, Middleware}
      iex> alias Exmen.Discover.Middleware.Math
      iex> middlewares = [%Middleware{module: Math}]
      iex> {:ok, pid} = Discoverer.start_link(middlewares)
      iex> files = Path.wildcard("./**/*.ex")
      iex> mutations = Discoverer.find_mutations_from_files(pid, files)
      iex> length(mutations) > 0
      true
  """
  def find_mutations_from_files(pid, files) do
    files
    |> Enum.map(fn file ->
      ast = Code.string_to_quoted!(File.read!(file))
      {file, find_mutations(pid, ast)}
    end)
  end

  def get_middlewares(pid) do
    GenServer.call(pid, :get_middleware)
  end

  def handle_call(:get_middleware, _from, state) do
    {:reply, state, state}
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
