defmodule Dictionary do
  @moduledoc """
  Documentation for `Dictionary`.
  """

  @word_list "../assets/words.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split(~r/\n/, trim: true)

  def random_word() do
    @word_list
    |> Enum.random()
  end
end
