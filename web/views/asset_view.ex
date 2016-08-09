defmodule Docput.AssetView do
  use Docput.Web, :view

  def s3_url(bucket, key \\ "") do
    "http://#{bucket}.s3.amazonaws.com/#{key}"
  end
end
