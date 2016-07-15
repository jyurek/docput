defmodule Docput.Renderer do
  def to_html(revision) do
    Docput.Repo.preload(revision, :layout)
    |> extract_layout_frontmatter
    |> extract_revision_frontmatter
    |> render_revision_mustache
    |> render_layout_mustache
    |> render_markdown
  end

  defp extract_layout_frontmatter(revision) do
    [_, yaml, _] = split_content(revision.layout.body)
    yaml = YamlElixir.read_from_string(yaml)
    %{yaml: yaml, revision: revision}
  end

  defp extract_revision_frontmatter(%{yaml: layout_yaml, revision: revision}) do
    [_, yaml, _] = split_content(revision.body)
    yaml = YamlElixir.read_from_string(yaml)
    %{yaml: Map.merge(layout_yaml, yaml), revision: revision}
  end

  defp render_revision_mustache(%{yaml: yaml, revision: revision}) do
    [_, _, body] = split_content(revision.body)
    %{yaml: yaml, content: Mustache.render(body, yaml), revision: revision}
  end
  
  defp render_layout_mustache(%{yaml: yaml, content: content, revision: revision}) do
    [_, _, body] = split_content(revision.layout.body)
    Mustache.render(body, yaml |> Map.put("content", content))
  end

  defp split_content(content) do
    content |> String.split(~r/--\s*/)
  end

  def render_markdown(markdown) do
    Earmark.to_html(markdown)
  end
end
