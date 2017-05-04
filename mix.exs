defmodule Otterx.Mixfile do
  use Mix.Project

  def project do
    [app: :otterx,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  defp package do
    # These are the default files included in the package
    [
      name: :otterx,
      files: ["lib/*.ex", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Heinz N. Gies"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/project-fifo/otterx"}
    ]
  end

  defp description do
    "OpenTracing library for Elixir"
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger, :otters]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev},
     {:otters, "~>0.2.0"}]
  end
end
