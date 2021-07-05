defmodule ShortUrlWeb.UrlView do

  use ShortUrlWeb, :view

  @doc """
  render post url
  """
  def render("url.json", %{status: :ok, response: params}) do
    %{
      "url"     => params[:url],
      "hash"    => params[:hash],
      "fullUrl" => params[:fullUrl]
    }
  end

  @doc """
  render Error
  """
  def render(_, %{status: :error, description: error_message}) do
    %{status: "error", description: error_message}
  end
end
