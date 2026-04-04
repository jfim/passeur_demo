defmodule PasseurDemoTest do
  use ExUnit.Case
  doctest PasseurDemo

  test "greets the world" do
    assert PasseurDemo.hello() == :world
  end
end
