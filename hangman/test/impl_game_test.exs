defmodule HangmanImplGameTest do
  use ExUnit.Case
  doctest Hangman

  alias Hangman.Impl.Game

  test "new_game/0" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters != []
    assert is_letters_lowercase?(game.letters)
  end

  test "new_game/1" do
    game = Game.new_game("wombat")

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters == ["w", "o", "m", "b", "a", "t"]
    assert is_letters_lowercase?(game.letters)
  end

  describe "make_move/0" do
    test "already won or lost" do
      for state <- [:won, :lost] do
        game =
          Game.new_game()
          |> Map.put(:game_state, state)

        {new_game, _} = Game.make_move(game, "x")

        assert game == new_game
      end
    end

    test "unused letter" do
      game = Game.new_game()

      {game, _} = Game.make_move(game, "x")

      assert game.game_state != :already_used
    end

    test "used letter" do
      game = Game.new_game()

      {game, _} = Game.make_move(game, "x")
      assert game.game_state != :already_used

      {game, _} = Game.make_move(game, "x")
      assert game.game_state == :already_used
    end

    test "good guess" do
      game = Game.new_game("wibble")

      {game, _} = Game.make_move(game, "w")
      assert game.game_state == :good_guess
      assert game.turns_left == 7
    end

    test "won" do
      game = Game.new_game("wibble")

      [
        {"w", :good_guess},
        {"i", :good_guess},
        {"b", :good_guess},
        {"l", :good_guess},
        {"e", :won}
      ]
      |> Enum.reduce(game, fn {guess, state}, game ->
        {game, _} = Game.make_move(game, guess)
        assert game.game_state == state
        assert game.turns_left == 7
        game
      end)
    end

    test "bad guess" do
      game = Game.new_game("wibble")

      {game, _} = Game.make_move(game, "x")
      assert game.game_state == :bad_guess
      assert game.turns_left == 6
    end

    test "lost" do
      game = Game.new_game("wibble")

      [
        {"a", :bad_guess, 6},
        {"c", :bad_guess, 5},
        {"d", :bad_guess, 4},
        {"f", :bad_guess, 3},
        {"g", :bad_guess, 2},
        {"h", :bad_guess, 1},
        {"j", :lost, 1}
      ]
      |> Enum.reduce(game, fn {guess, state, turns_left}, game ->
        {game, _} = Game.make_move(game, guess)
        assert game.game_state == state
        assert game.turns_left == turns_left
        game
      end)
    end
  end

  describe "tally/1" do
    test "new game" do
      tally = Game.new_game("wibble") |> Game.tally()
      assert tally.game_state == :initializing
      assert tally.turns_left == 7
      assert tally.letters == ["_", "_", "_", "_", "_", "_"]
    end

    test "single good guess" do
      {_, tally} = Game.new_game("wibble") |> Game.make_move("w")
      assert tally.game_state == :good_guess
      assert tally.turns_left == 7
      assert tally.letters == ["w", "_", "_", "_", "_", "_"]
    end

    test "double good guess" do
      {_, tally} = Game.new_game("wibble") |> Game.make_move("b")
      assert tally.game_state == :good_guess
      assert tally.turns_left == 7
      assert tally.letters == ["_", "_", "b", "b", "_", "_"]
    end

    test "bad guess" do
      {_, tally} = Game.new_game("wibble") |> Game.make_move("a")
      assert tally.game_state == :bad_guess
      assert tally.turns_left == 6
      assert tally.letters == ["_", "_", "_", "_", "_", "_"]
    end
  end

  defp is_letters_lowercase?([]), do: true
  defp is_letters_lowercase?([h | t]), do: String.downcase(h) == h and is_letters_lowercase?(t)
end
