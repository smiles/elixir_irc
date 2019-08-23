defmodule ABotTest do
  use ExUnit.Case
  doctest ABot

  test "greets the world" do
    assert ABot.hello() == :world
  end
end
