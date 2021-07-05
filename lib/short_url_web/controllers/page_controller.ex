defmodule ShortUrlWeb.PageController do
  use ShortUrlWeb, :controller

  alias ShortUrl.Schema.ShortUrl, as: ShortUrlRecord
  alias ShortUrl.ShortUrlQueries

  require Logger

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  # GET /:hash
  def forward_url(conn, %{"hash" => hash} = params) do
    Logger.info(~s|forward_url params=#{inspect(params)}|)

    with {:ok, %ShortUrlRecord{}=record} <- ShortUrlQueries.get_url(hash)
    do
      Logger.info("get_url forwarding to url=#{record.url}")
      conn
      |> put_status(:moved_permanently)
      |> redirect(external: record.url)

    else
      {:error, reason} ->
        Logger.error(~s|Error get_url params=#{inspect(params)} reason=#{inspect(reason)}|)
        render(conn, "404.html")
    end
  end

  # GET all the other url
  def not_found(conn, _params) do
    Logger.info(~s|not_found request|)

    render(conn, "404.html")
  end
end
