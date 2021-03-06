defmodule TextClient.Impl.Mover do
  alias TextClient.Impl.State

  def make_move(game) do
    {game_service, tally} = Hangman.make_move(game.game_service, game.guess)
    %State{game | game_service: game_service, tally: tally}
  end
end
