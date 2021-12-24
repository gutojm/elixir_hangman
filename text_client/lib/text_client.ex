defmodule TextClient do
  @moduledoc """
  Documentation for `TextClient`.
  """

  defdelegate start(), to: TextClient.Interact
end
