defmodule Exmen.Discover.Middleware.Conditional do
  alias Exmen.Discover.Middleware

  def find_mutations(ast) do
    Middleware.run(ast, &mutate/1)
  end

  defp mutate({:if, meta, args}) do
    {:ok, {:unless, meta, args}, args}
  end
  defp mutate(_), do: nil
end
