defmodule Mix.Tasks.Mutate do
  alias Exmen.Discover.{Discoverer, Middleware}
  alias Exmen.Discover.Middleware.{Math, Conditional}

  def run(_opts) do
    Mix.env(:test)

    ExUnit.start([autorun: false, verbose: true])
    tests = Path.wildcard("./test/**/*_test.exs")

    middlewares = [
      %Middleware{module: Math},
      %Middleware{module: Conditional}
    ]

    {:ok, discoverer} = Discoverer.start_link(middlewares)

    source_files = Path.wildcard("./lib/**/*.ex")
    mutations = Discoverer.find_mutations_from_files(discoverer, source_files)

    Enum.each(mutations, fn _ ->
      Enum.each(tests, &Code.load_file/1)
      Mix.Tasks.Test.run([])
      Code.unload_files(tests)
    end)

    Mix.shell.info("failures: 0")
  end
end
