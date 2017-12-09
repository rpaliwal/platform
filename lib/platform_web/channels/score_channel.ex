defmodule PlatformWeb.ScoreChannel do
  use PlatformWeb, :channel

  alias Platform.Accounts
  alias Platform.Products

  def join("score:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (score:lobby).
  def handle_in("shout", %{"player_score" => player_score} = payload, socket) do
    Products.create_gameplay(%{player_id: socket.assigns.player_id, game_id: 1, player_score: player_score})
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
