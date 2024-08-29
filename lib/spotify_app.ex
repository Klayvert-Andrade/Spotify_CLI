defmodule SpotifyApp do
  @spotify_base_url "https://api.spotify.com/v1"

  # Função auxiliar para lidar com requisições ao Spotify API
  defp fetch_data(endpoint) do
    case SpotifyClient.get(endpoint) do
      {:ok, response} -> {:ok, response}
      {:error, reason} -> {:error, reason}
    end
  end

  def search_artist(name) do
    query = URI.encode(name)
    url = "#{@spotify_base_url}/search?q=#{query}&type=artist"

    case fetch_data(url) do
      {:ok, %{"artists" => %{"items" => [artist | _]}}} ->
        {:ok, artist}
      {:ok, %{"artists" => %{"items" => []}}} ->
        {:error, "No artists found"}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def search_track(name) do
    query = URI.encode(name)
    url = "#{@spotify_base_url}/search?q=#{query}&type=track"

    case fetch_data(url) do
      {:ok, %{"tracks" => %{"items" => [track | _]}}} ->
        {:ok, track}
      {:ok, %{"tracks" => %{"items" => []}}} ->
        {:error, "No tracks found"}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def search_album(name) do
    query = URI.encode(name)
    url = "#{@spotify_base_url}/search?q=#{query}&type=album"

    case fetch_data(url) do
      {:ok, %{"albums" => %{"items" => [album | _]}}} ->
        {:ok, album}
      {:ok, %{"albums" => %{"items" => []}}} ->
        {:error, "No albums found"}
      {:error, reason} ->
        {:error, reason}
    end
  end

  # Buscar todos os álbuns de um artista
  def search_artist_albums(artist_name) do
    case search_artist(artist_name) do
      {:ok, artist} ->
        artist_id = artist["id"]
        url = "#{@spotify_base_url}/artists/#{artist_id}/albums"

        case fetch_data(url) do
          {:ok, %{"items" => [_ | _] = albums}} -> {:ok, albums}
          {:ok, %{"items" => []}} -> {:error, "No albums found for artist"}
          {:error, reason} -> {:error, reason}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  # Buscar todas as faixas de um álbum
  def search_album_tracks(album_name) do
    case search_album(album_name) do
      {:ok, album} ->
        album_id = album["id"]
        url = "#{@spotify_base_url}/albums/#{album_id}/tracks"

        case fetch_data(url) do
          {:ok, %{"items" => tracks}} when is_list(tracks) and length(tracks) > 0 ->
            {:ok, tracks}
          {:ok, %{"items" => []}} -> {:error, "No tracks found for album"}
          {:error, reason} -> {:error, reason}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  # Buscar as 5 principais faixas de um artista
  def get_artist_top_tracks(artist_name) do
    case search_artist(artist_name) do
      {:ok, artist} ->
        artist_id = artist["id"]
        url = "#{@spotify_base_url}/artists/#{artist_id}/top-tracks?market=US"

        case fetch_data(url) do
          {:ok, %{"tracks" => tracks}} when is_list(tracks) ->
            {:ok, Enum.take(tracks, 5)}
          {:error, reason} -> {:error, reason}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end
end
