defmodule Ch8Test do
  use ExUnit.Case
  doctest Ch8

  test "greets the world" do
    assert Ch8.hello() == :world
  end
end
