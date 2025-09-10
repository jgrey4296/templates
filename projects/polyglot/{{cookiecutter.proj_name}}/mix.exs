# #  mix.exs -*- mode: elixir -*-
# #  mix.exs -*- mode: elixir
# https://hexdocs.pm/mix/1.18.4/Mix.html


defmodule {{cookiecutter.proj_name|title}}.MixProject do
  use Mix.Project

  def project do
    [
      app: :{{cookiecutter.proj_name}},
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      build_path: ".temp/build",
      config_path: "./config.exs",
      elixirc_paths: ["src/ex_{{cookiecutter.proj_name}}"],
      elixirc_options: [warnings_as_errors: true],
      test_paths: ["src/ex_{{cookiecutter.proj_name}}/test"],
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
