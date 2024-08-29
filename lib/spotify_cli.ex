defmodule SpotifyCLI do
  def run() do
    loop()
  end

  # Função principal de loop que exibe o menu e processa as escolhas do usuário.
  defp loop do
    clear_screen()
    show_menu()

    option =
      IO.gets("> ")
      |> String.trim()
      |> String.to_integer()

    case option do
      1 -> handle_artist_info()
      2 -> handle_track_info()
      3 -> handle_album_info()
      4 -> handle_artist_albums()
      5 -> handle_album_tracks()
      6 -> exit_program()
      _ -> IO.puts("Opção inválida. Tente Novamente.")
    end

    loop()
  end

  defp clear_screen do
    IO.write(IO.ANSI.clear())
    IO.write(IO.ANSI.home())
  end

  # Exibe o menu de opções para o usuário.
  defp show_menu do
    IO.puts("MENU - Spotify CLI:")
    IO.puts("\n1. Obter informações de um artista")
    IO.puts("2. Obter informações de uma música")
    IO.puts("3. Obter informações de um álbum")
    IO.puts("4. Listar álbuns de um artista")
    IO.puts("5. Listar faixas de um álbum")
    IO.puts("6. Sair")
    IO.puts("Selecione uma opção:")
  end

  # Lida com a obtenção de informações de um artista.
  defp handle_artist_info do
    IO.puts("Digite o nome do artista:")
    name = IO.gets("> ") |> String.trim()

    case SpotifyApp.search_artist(name) do
      {:ok, artist} ->
        format_artist(artist)
        show_artist_top_tracks(name)
      {:error, reason} ->
        IO.puts("Erro ao buscar artista: #{reason}")
    end
  end

  # Lida com a obtenção de informações de uma música.
  defp handle_track_info do
    IO.puts("Digite o nome da música:")
    track_name = IO.gets("> ") |> String.trim()

    case SpotifyApp.search_track(track_name) do
      {:ok, track} -> format_track(track)
      {:error, reason} -> IO.puts("Erro ao buscar música: #{reason}")
    end
  end

  # Lida com a obtenção de informações de um álbum.
  defp handle_album_info do
    IO.puts("Digite o nome do álbum:")
    album_name = IO.gets("> ") |> String.trim()

    case SpotifyApp.search_album(album_name) do
      {:ok, album} -> format_album(album)
      {:error, reason} -> IO.puts("Erro ao buscar álbum: #{reason}")
    end
  end

  # Lida com a listagem de álbuns de um artista.
  defp handle_artist_albums do
    IO.puts("Digite o nome do artista: ")
    artist_name = IO.gets("> ") |> String.trim()

    case SpotifyApp.search_artist_albums(artist_name) do
      {:ok, albums} when is_list(albums) and length(albums) > 0 ->
        Enum.each(albums, &format_album/1)
      {:ok, _} ->
        IO.puts("Nenhum álbum encontrado para o artista.")
      {:error, reason} ->
        IO.puts("Erro ao buscar álbuns: #{reason}")
    end
  end

  # Lida com a listagem de faixas de um álbum.
  defp handle_album_tracks do
    IO.puts("Digite o nome do álbum:")
    album_name = IO.gets("> ") |> String.trim()

    case SpotifyApp.search_album_tracks(album_name) do
      {:ok, tracks} when is_list(tracks) and length(tracks) > 0 ->
        Enum.each(tracks, &format_track/1)
      {:error, reason} ->
        IO.puts("Erro ao buscar faixas: #{reason}")
    end
  end

  # Exibe as músicas populares de um artista.
  defp show_artist_top_tracks(name) do
    case SpotifyApp.get_artist_top_tracks(name) do
      {:ok, tracks} ->
        IO.puts("Músicas Populares do(a) Artista:\n")
        Enum.each(tracks, &format_track/1)
      {:error, reason} ->
        IO.puts("Erro ao buscar top músicas: #{reason}")
    end
  end

  # Função para formatar e exibir informações de um artista.
  defp format_artist(%{
         "name" => name,
         "popularity" => popularity,
         "genres" => genres,
         "followers" => %{"total" => followers},
         "external_urls" => %{"spotify" => spotify_url},
         "images" => images
       }) do
    IO.puts("\nInformações do(a) Artista:")
    IO.puts("\nNome: #{name}")
    IO.puts("Popularidade: #{popularity}")
    IO.puts("Gêneros: #{Enum.join(genres, ", ")}")
    IO.puts("Seguidores: #{followers}")
    IO.puts("URL do Spotify: #{spotify_url}")
    IO.puts("Imagens:")

    Enum.each(images, fn image ->
      IO.puts(" - URL: #{image["url"]} (#{image["width"]}x#{image["height"]})")
    end)

    IO.puts("\n")
  end

  # Função para formatar e exibir informações de uma música.
  defp format_track(%{
         "name" => name,
         "artists" => artists,
         "external_urls" => %{"spotify" => spotify_url},
         "album" => %{"name" => album_name, "release_date" => release_date}
       }) do
    IO.puts("\nInformações da Música:")
    IO.puts("\nNome: #{name}")
    IO.puts("Artistas: #{Enum.map(artists, & &1["name"]) |> Enum.join(", ")}")
    IO.puts("Álbum: #{album_name}")
    IO.puts("Data de Lançamento: #{release_date}")
    IO.puts("URL do Spotify: #{spotify_url}")
    IO.puts("\n")
  end

  # Caso a música não tenha informações de álbum.
  defp format_track(%{
         "name" => name,
         "artists" => artists,
         "external_urls" => %{"spotify" => spotify_url}
       }) do
    IO.puts("\nInformações da Música:")
    IO.puts("\nNome: #{name}")
    IO.puts("Artistas: #{Enum.map(artists, & &1["name"]) |> Enum.join(", ")}")
    IO.puts("URL do Spotify: #{spotify_url}")
    IO.puts("-------------------------------------------------")
  end

  # Função para formatar e exibir informações de um álbum.
  defp format_album(%{
         "name" => name,
         "artists" => artists,
         "release_date" => release_date,
         "external_urls" => %{"spotify" => spotify_url},
         "images" => images
       }) do
    IO.puts("\nInformações do Álbum:")
    IO.puts("\nNome: #{name}")
    IO.puts("Artistas: #{Enum.map(artists, & &1["name"]) |> Enum.join(", ")}")
    IO.puts("Data de Lançamento: #{release_date}")
    IO.puts("URL do Spotify: #{spotify_url}")
    IO.puts("Imagens:")

    Enum.each(images, fn image ->
      IO.puts(" - URL: #{image["url"]} (#{image["width"]}x#{image["height"]})")
    end)

    IO.puts("\n")
  end

  # Função para encerrar o programa.
  defp exit_program do
    IO.puts("Saindo...")
    System.halt()
  end
end
