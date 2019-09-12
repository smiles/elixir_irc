defmodule LoggerPlugTest do
  use ExUnit.Case
  doctest LoggerPlug

  test "greets the world" do
    assert LoggerPlug.hello() == :world
  end
end
