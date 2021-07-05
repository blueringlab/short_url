defmodule ShortUrlWeb.UrlController do
  use ShortUrlWeb, :controller
  require Logger

  alias ShortUrl.Schema.ShortUrl, as: ShortUrlRecord
  alias ShortUrl.ShortUrlProcessor
  alias ShortUrl.ShortUrlQueries

  # GET /api/url/:hash
  def get_url(conn, %{"hash" => hash} = params) do
    Logger.info(~s|get_url params=#{inspect(params)}|)

    with {:ok, %ShortUrlRecord{}=record} <- ShortUrlQueries.get_url(hash)
    do
      Logger.info("get_url success params=#{inspect(record)}")
      full_short_url = ShortUrlWeb.Router.Helpers.url(conn) <> "/" <> record.hash

      {:ok, [hash: record.hash, url: record.url, fullUrl: full_short_url]}
      |> render_url(conn)
    else
      {:error, reason} ->
        Logger.error(~s|Error get_url params=#{inspect(params)} reason=#{inspect(reason)}|)
        {:error, reason}
        |> render_url(conn)
    end
  end

  # POST /api/url
  def create_url(conn, %{"url" => url} = params) do
    Logger.info(~s|create_url params=#{inspect(params)}|)

    with  :ok           <- validate_url(url),
          {:ok, result} <- ShortUrlProcessor.save_hash_url(url)
    do
      full_short_url = ShortUrlWeb.Router.Helpers.url(conn) <> "/" <> result[:hash]
      final_result = result ++ [fullUrl: full_short_url]
      Logger.info("create_url success params=#{inspect(params)}, result=#{inspect(final_result)}")

      {:ok, final_result}
      |> render_url(conn)
    else
      {:error, reason} ->
        Logger.error(~s|Error create_url params=#{inspect(params)} reason=#{inspect(reason)}|)
        {:error, reason}
        |> render_url(conn)
    end
  end

  defp validate_url(url) do
    uri = URI.parse(url)
    # scheme should not be null and host should include '.'
    if uri.scheme != nil && uri.host =~ "." do
      :ok
    else
      {:error, :bad_url}
    end
  end

  # ------------------------------------------------------------------------------------------------
  # Rendering POST responses
  # ------------------------------------------------------------------------------------------------
  defp render_url({:ok, params}, conn) do
    Logger.info(~s|render_url  post_resp=#{inspect(params)}|)
    conn
    |> put_status(200)
    |> render("url.json", %{status: :ok, response: params})
  end

  defp render_url({:error, :bad_url}, conn) do
    conn
    |> put_status(400)
    |> render("400.json", %{status: :error, description: "Bad request url"})
  end

  defp render_url({:error, :not_found}, conn) do
    conn
    |> put_status(404)
    |> render("404.json", %{status: :error, description: "Not found"})
  end

  defp render_url({:error, :not_unique_hash}, conn) do
    conn
    |> put_status(409)
    |> render("409.json", %{status: :error, description: "Duplicate hash"})
  end

  defp render_url({:error, _error_message}, conn) do
    conn
    |> put_status(400)
    |> render("400.json", %{status: :error, description: "Bad data"})
  end
end
