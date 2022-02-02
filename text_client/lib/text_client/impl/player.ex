defmodule TextClient.Impl.Player do
  alias TextClient.Impl.{Mover, Prompter, State, Summary}

  @typep game :: Hangman.game()
  @typep tally :: Hangman.tally()
  @typep state :: {game, tally}

  @spec start :: :ok
  def start() do
    Hangman.new_game()
    |> setup_state()
    |> play()
  end

  defp setup_state(game) do
    %State{
      game_service: game,
      tally: Hangman.tally(game)
    }
  end

  @spec play(state) :: :ok
  def play(%State{tally: %{game_state: :won}}) do
    exits_with_message("You WON!")
  end

  def play(%State{tally: %{game_state: :lost}, game_service: game}) do
    exits_with_message("You LOST... the word was #{game.letters |> Enum.join()}")
  end

  def play(state = %State{tally: tally = %{game_state: :initializing}}) do
    continue_with_message(state, "Welcome! It's a #{tally.letters |> length()} letter word")
  end

  def play(state = %State{tally: %{game_state: :good_guess}}) do
    continue_with_message(state, "Good guess!")
  end

  def play(state = %State{tally: %{game_state: :bad_guess}}) do
    continue_with_message(state, "Bad guess!")
  end

  def play(game = %State{tally: %{game_state: :already_used}}) do
    continue_with_message(game, "Already used!")
  end

  def play(game) do
    continue(game)
  end

  defp continue_with_message(state, msg) do
    IO.puts(msg)
    continue(state)
  end

  defp continue(state) do
    state
    |> Summary.display()
    |> Prompter.accept_move()
    |> Mover.make_move()
    |> play()
  end

  defp exits_with_message(msg) do
    IO.puts(msg)
    :ok
  end
end
