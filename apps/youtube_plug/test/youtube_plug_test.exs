defmodule YoutubePlugTest do
  use ExUnit.Case
  doctest YoutubePlug

  test "greets the world" do
    assert YoutubePlug.hello() == :world
  end
end
