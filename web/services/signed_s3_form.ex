defmodule Docput.SignedS3Form do
  alias Ecto.DateTime

  def encoded_policy(date, destination_url) do
    date
    |> policy(destination_url)
    |> Poison.encode!
    |> Base.encode64(padding: true)
  end

  defp policy(date, destination_url) do
    %{
      "expiration": expiration,
      "conditions": [
        %{"bucket" => Application.get_env(:docput, :s3)[:bucket]},
        %{"acl" => "public-read"},
        ["starts-with", "$key", ""],
        ["starts-with", "$Content-Type", "image/"],
        ["content-length-range", 0, 100 * 1024],
        %{"success_action_redirect" => destination_url },
        %{"x-amz-credential" => credential_token(date)},
        %{"x-amz-algorithm" => "AWS4-HMAC-SHA256"},
        %{"x-amz-date" => date |> to_amz_date }
      ]
    }
  end

  def expiration(time \\ DateTime.utc) do
    (Map.put(time, :hour, time.hour + 1) |> DateTime.to_iso8601) <> "Z"
  end

  def credential_token(date) do
    "#{Application.get_env(:docput, :s3)[:access_key]}/#{date |> to_short_date}/us-east-1/s3/aws4_request"
  end

  defp encrypt(key, val) do
    :crypto.hmac(:sha256, key, val)
  end

  def signature(base64_policy, date) do
    signing_key(date)
    |> encrypt(base64_policy)
    |> Base.encode16(case: :lower)
  end

  def signing_key(date, region \\ "us-east-1", service \\ "s3") do
    "AWS4" <> Application.get_env(:docput, :s3)[:secret_key]
    |> encrypt(date |> to_short_date)
    |> encrypt(region)
    |> encrypt(service)
    |> encrypt("aws4_request")
  end

  def to_amz_date(date) do
    (date |> DateTime.to_iso8601 |> String.replace(~r/(\.|-|:)/, "")) <> "Z"
  end

  def to_short_date(date) do
    date |> to_amz_date |> String.split("T") |> List.first
  end
end
