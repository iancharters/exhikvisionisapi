defmodule ExHikvisionIsapi.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_hikvision_isapi,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      #mod: {EXHikvisionISAPI, []}, 
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.0"}
    ]
  end
end
