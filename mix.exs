defmodule Exmen.Mixfile do
  use Mix.Project

  def project do
    [app: :exmen,
     version: "0.1.0",
     description: description,
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  def description do
    """
    A marvelous mutation testing tool for Elixir
    """
  end

  def package do
    [name: :exmen,
     licenses: ["MIT"],
     maintainers: ["Thomas Farla"],
     links: %{"Github" => "https://github.com/TFarla/exmen"}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev}]
  end
end
