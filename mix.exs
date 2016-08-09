defmodule Docput.Mixfile do
  use Mix.Project

  def project do
    [app: :docput,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Docput, []},
     applications: app_list]
  end

  defp app_list, do: [
    :bamboo,
    :cowboy,
    :gettext,
    :logger,
    :phoenix,
    :phoenix_ecto,
    :phoenix_html,
    :postgrex,
    :timex,
    :timex_ecto,
    :yaml_elixir
  ]

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bamboo, "~> 0.4"},
      {:cowboy, "~> 1.0"},
      {:earmark, "~> 0.1.17"},
      {:envy, "~> 0.0.2"},
      {:exgravatar, "~> 0.2"},
      {:gettext, "~> 0.9"},
      {:mustache, "~> 0.2.0"},
      {:oauth2, "~> 0.5"},
      {:phoenix, "~> 1.2.0"},
      {:phoenix_ecto, "~> 3.0.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:postgrex, ">= 0.0.0"},
      {:quick_alias, "~> 0.1.0"},
      {:secure_random, "~> 0.1"},
      {:timex, "~>2.2.1"},
      {:timex_ecto, "~>1.1.3"},
      {:yamerl, github: "yakaz/yamerl"},
      {:yaml_elixir, "~> 1.2"}
    ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
