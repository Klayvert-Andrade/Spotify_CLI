defmodule SpotifyCLITest do
  use ExUnit.Case
  doctest SpotifyCLI

  test "greets the world" do
    assert SpotifyCLI.hello() == :world
  end
end
