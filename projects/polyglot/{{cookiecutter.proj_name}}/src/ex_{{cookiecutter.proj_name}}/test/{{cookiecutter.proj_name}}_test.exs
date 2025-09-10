# #  {{cookiecutter.proj_name}}_test.exs -*- mode: elixir -*-


defmodule {{cookiecutter.proj_name|title}}Test do
  use ExUnit.Case
  doctest {{cookiecutter.proj_name|title}}

  test "greets the world" do
    assert {{cookiecutter.proj_name|title}}.hello() == :world
  end
end
