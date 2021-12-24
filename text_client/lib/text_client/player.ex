defmodule TextClient.Player do
  alias TextClient.{Mover, Prompter, State, Summary}

  def play(%State{tally: %{game_state: :won}}) do
    exits_with_message("You WON!")
  end

  def play(%State{tally: %{game_state: :lost}}) do
    exits_with_message("You LOST!")
  end


  def play(game = %State{tally: %{game_state: :good_guess}}) do
    continue_with_message(game, "Good guess!")
  end

  def play(game = %State{tally: %{game_state: :bad_guess}}) do
    continue_with_message(game, "Bad guess!")
  end

  def play(game = %State{tally: %{game_state: :already_used}}) do
    continue_with_message(game, "Already used!")
  end

  def play(game) do
    continue(game)
  end

  defp continue_with_message(game, msg) do
    IO.puts(msg)
    continue(game)
  end

  defp continue(game) do
    game
    |> Summary.display()
    |> Prompter.accept_move()
    |> Mover.make_move()
    |> play()
  end

  defp exits_with_message(msg) do
    IO.puts(msg)
    exit(:normal)
  end
end
