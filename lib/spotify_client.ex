defmodule SpotifyClient do

  # Define as credenciais do cliente Spotify (Client ID e Client Secret)
  # Credenciais definidas ao fazer o cadastro em: https://developer.spotify.com/dashboard/create
  @client_id "0fade1c4bc8c4bc8a65c5cdfe5b06f44"
  @client_secret "7456b185dd7447c88a1d220f99dd020d"

  # URL usada para obter o token de acesso
  @token_url "https://accounts.spotify.com/api/token"

  # Função para obter o token de acesso necessário para autenticar as requisições à API do Spotify
  def get_access_token() do
    # Cabeçalhos necessários para a requisição POST
    headers = [
      {"Authorization", "Basic #{Base.encode64("#{@client_id}:#{@client_secret}")}"},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]

    # Corpo da requisição indicando que queremos um token de acesso usando client credentials
    body = "grant_type=client_credentials"

     # Faz a requisição POST para obter o token de acesso
    case HTTPoison.post(@token_url, body, headers) do
      {:ok, response} ->
        body = response.body

         # Tenta decodificar o JSON de resposta para extrair o token de acesso
        case Jason.decode(body) do
          {:ok, %{"access_token" => token}} ->
            {:ok, token}
          {:error, reason} ->
            {:error, reason}
        end
      {:error, reason} ->
        {:error, "Falha ao decodificar o corpo da resposta para token de acesso: #{reason}"}
    end
  end


 # Função para fazer uma requisição GET à API do Spotify usando o token de acesso
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
