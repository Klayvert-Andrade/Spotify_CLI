# Módulo que interage com a API do Spotify, fazendo buscas w obtendo informações sobre artistas, álbuns e faixas

defmodule SpotifyApp do
  # constante que armazena a URL base da API do Spotify.
  @spotify_base_url "https://api.spotify.com/v1"

  # Função auxiliar para lidar com requisições à API do Spotify
  defp fetch_data(endpoint) do
    case SpotifyClient.get(endpoint) do
      {:ok, response} ->
        {:ok, response}
      {:error, reason} ->
        {:error, reason}
    end
  end

  # Função para buscar informações sobre um artista pelo nome
  def search_artist(name) do
    # codifica a string name de modo que fique compatível com uma URL
    query = URI.encode(name)
    url = "#{@spotify_base_url}/search?q=#{query}&type=artist"

    # Faz a requisição e tenta encontrar o artista
    case fetch_data(url) do
      {:ok, %{"artists" => %{"items" => [artist | _]}}} ->
        # Retorna o primeiro artista encontrado
        {:ok, artist}

      {:ok, %{"artists" => %{"items" => []}}} ->
        {:error, "Nenhum artista encontrado com esse nome"}

      {:error, reason} ->
        {:error, "Erro ao buscar o artista: #{reason}"}
    end
  end

  # Função para buscar informações sobre uma música pelo nome
  def search_track(name) do
    query = URI.encode(name)
    url = "#{@spotify_base_url}/search?q=#{query}&type=track"

    case fetch_data(url) do
      {:ok, %{"tracks" => %{"items" => [track | _]}}} ->
        {:ok, track}

      {:ok, %{"tracks" => %{"items" => []}}} ->
        {:error, "Nenhuma música encontrada com esse nome"}

      {:error, reason} ->
        {:error, "Erro ao buscar o artista: #{reason}"}
    end
  end

  # Função para buscar informações sobre um álbum pelo nome
  def search_album(name) do
    query = URI.encode(name)
    url = "#{@spotify_base_url}/search?q=#{query}&type=album"

    case fetch_data(url) do
      {:ok, %{"albums" => %{"items" => [album | _]}}} ->
        {:ok, album}

      {:ok, %{"albums" => %{"items" => []}}} ->
        {:error, "Nenhum álbum encontrado com esse nome"}

      {:error, reason} ->
        {:error, "Erro ao buscar o artista: #{reason}"}
    end
  end

  # Função para buscar todos os álbuns de um artista
  def search_artist_albums(artist_name) do
    case search_artist(artist_name) do
      {:ok, artist} ->
        artist_id = artist["id"]
        url = "#{@spotify_base_url}/artists/#{artist_id}/albums"

        case fetch_data(url) do
          {:ok, %{"items" => [_ | _] = albums}} ->
            {:ok, albums}

          {:ok, %{"items" => []}} ->
            {:error, "Nenhum álbum do artista foi encontrado para o artista #{artist_name}"}

          {:error, reason} ->
            {:error, "Erro ao buscar o artista: #{reason}"}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

    # Função para buscar todas as faixas de um álbum
  def search_album_tracks(album_name) do
    case search_album(album_name) do
      {:ok, album} ->
        album_id = album["id"]
        url = "#{@spotify_base_url}/albums/#{album_id}/tracks"

        case fetch_data(url) do
          {:ok, %{"items" => tracks}} when is_list(tracks) and length(tracks) > 0 ->
            {:ok, tracks}

          {:ok, %{"items" => []}} ->
            {:error, "Nenhuma música encontrada para o álbum"}

          {:error, reason} ->
            {:error, "Erro ao buscar o artista: #{reason}"}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  # Função para buscar as 5 principais faixas de um artista
  def get_artist_top_tracks(artist_name) do
    case search_artist(artist_name) do
      {:ok, artist} ->
        artist_id = artist["id"]
        url = "#{@spotify_base_url}/artists/#{artist_id}/top-tracks?market=US"

        case fetch_data(url) do
          {:ok, %{"tracks" => tracks}} when is_list(tracks) ->
            # Retorna as 5 principais faixas do artista
            {:ok, Enum.take(tracks, 5)}
          {:error, reason} ->
            {:error, "Erro ao buscar o artista: #{reason}"}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end
end
