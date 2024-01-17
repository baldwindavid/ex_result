defmodule ExResult.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_result,
      version: "0.0.5",
      elixir: "~> 1.14",
      description: "Helpers for wrapping, unwrapping, and transforming result tuples",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  def docs do
    [
      main: "ExResult",
      source_url_pattern: "https://github.com/baldwindavid/ex_result/blob/main/%{path}#L%{line}"
    ]
  end

  def package do
    [
      maintainers: ["David Baldwin"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/baldwindavid/ex_result"},
      files: ~w(mix.exs README.md lib)
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
