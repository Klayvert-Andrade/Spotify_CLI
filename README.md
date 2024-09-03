# Spotify with Elixir

**Aplicação de Linha de Comando em Elixir para Consumo de API REST**

Este projeto visa desenvolver uma aplicação em Elixir que interage com uma API REST externa, exibindo informações do Spotify selecionadas pelo usuário através de linha de comando.

**Requisitos**
- Consumo de API REST: a aplicação deve ser capaz de enviar requisições HTTP para uma API REST especificada e processar as respostas em formato JSON.
- Exibição de Informações: as informações obtidas da API devem ser apresentadas ao usuário de forma clara e organizada no terminal.
- Argumentos de Linha de Comando: a aplicação aceita argumentos na linha de comando que permita ao usuário filtrar ou selecionar quais informações serão exibidas.

Requisitos Técnicos
- Linguagem: Elixir
- Interface: Linha de comando
- Comunicação: HTTP (requisições e respostas)
- Formato de Dados: JSON
- Bibliotecas: HTTPoison e JSON
  
## Como executar
Com o Elixir instalado e na pasta do diretório cloando, execute no terminal:
```shell
mix deps.get
mix run -e 'SpotifyCLI.run()'
```
  
## Módulo SpotifyClient
Este módulo Elixir fornece funcionalidades para interagir com a API do Spotify, incluindo:

- Autenticação: obtém um token de acesso usando suas credenciais de cliente (Client ID e Client Secret).
- Requisições GET: realiza requisições GET à API do Spotify, incluindo o token de acesso para autenticação.
- Tratamento de Respostas: decodifica as respostas JSON da API e retorna os dados ou erros de forma estruturada.

Como Usar:

- Configure suas credenciais: substitua @client_id e @client_secret pelos valores obtidos ao registrar sua aplicação no Spotify Developer Dashboard.
 

## Módulo SpotifyCli
Este módulo Elixir oferece uma interface de linha de comando interativa para buscar e exibir informações sobre artistas, músicas e álbuns do Spotify.

Funcionalidades

- Menu Interativo: apresenta um menu com opções para buscar informações sobre artistas, músicas, álbuns, listar álbuns de um artista, listar faixas de um álbum e sair do programa.
- Busca e Exibição de Informações: permite ao usuário inserir o nome de um artista, música ou álbum e exibe informações detalhadas sobre eles, incluindo nome, popularidade, gêneros, seguidores, URL do Spotify, etc.
- Listagem de Álbuns e Faixas: permite listar os álbuns de um artista ou as faixas de um álbum.
- Exibição de Músicas Populares: ao buscar informações sobre um artista, também exibe suas músicas mais populares.
- Tratamento de Erros: lida com possíveis erros durante a busca de informações na API do Spotify e exibe mensagens informativas ao usuário.
- Limpeza de Tela: utiliza comandos para limpar a tela antes de exibir o menu ou os resultados das buscas, proporcionando uma experiência mais organizada.


## Módulo Spotify App
Este módulo oferece funcionalidades para buscar e obter informações sobre artistas, álbuns e faixas da API do Spotify.

Funcionalidades

- Busca por Artista: permite buscar um artista pelo nome e retorna suas informações detalhadas, como nome, popularidade, gêneros, número de seguidores e URL do Spotify.
- Busca por Música: permite buscar uma música pelo nome e retorna suas informações, como nome, artistas, álbum, data de lançamento e URL do Spotify.
- Busca por Álbum: permite buscar um álbum pelo nome e retorna suas informações, como nome, artistas, data de lançamento, número total de faixas e URL do Spotify.
- Listagem de Álbuns de um Artista: busca todos os álbuns de um artista específico.
- Listagem de Faixas de um Álbum: busca todas as faixas de um álbum específico.
- Obtenção das Principais Faixas de um Artista: retorna as 5 principais faixas de um artista.
- Tratamento de Erros: lida com possíveis erros durante as requisições à API do Spotify e retorna mensagens de erro informativas.