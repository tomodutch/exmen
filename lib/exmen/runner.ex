defmodule Exmen.Runner do
  def run(tests) do
    Enum.each(tests, &Code.load_file/1)
    ExUnit.start([autorun: false, formatters: []])
    ExUnit.run()
  end
end
