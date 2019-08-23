defmodule ElixirIrcTest do
  use ExUnit.Case
  doctest ElixirIrc

  test "greets the world" do
    assert ElixirIrc.hello() == :world
  end
end
