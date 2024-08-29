defmodule SpotifyClient do

  @client_id "0fade1c4bc8c4bc8a65c5cdfe5b06f44"
  @client_secret "7456b185dd7447c88a1d220f99dd020d"
  @token_url "https://accounts.spotify.com/api/token"

  def get_access_token() do
    headers = [
      {"Authorization", "Basic #{Base.encode64("#{@client_id}:#{@client_secret}")}"},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]

    body = "grant_type=client_credentials"

    case HTTPoison.post(@token_url, body, headers) do
      {:ok, response} ->
        body = response.body
        case Jason.decode(body) do
          {:ok, %{"access_token" => token}} ->
            {:ok, token}
          {:error, reason} ->
            {:error, reason}
        end
      {:error, reason} ->
        {:error, reason}
    end
  end

  def get(url) do
    case get_access_token() do
      {:ok, token} ->
        headers = [
          {"Authorization", "Bearer #{token}"}
        ]

        case HTTPoison.get(url, headers) do
          {:ok, response} ->
            body = response.body
            {:ok, Jason.decode!(body)}
          {:error, reason} ->
            {:error, reason}
        end
      {:error, reason} ->
        {:error, reason}
    end
  end
end
