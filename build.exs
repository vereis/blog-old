#! /usr/bin/env elixir
# ==============================================#
# Implementation                               #
# ==============================================#
defmodule S do
  @posts_dir "posts"
  @blog_dir "blog"

  def init() do
    :ok = File.mkdir_p(@posts_dir)
    :ok = File.mkdir_p(@blog_dir)
  end

  def list_posts() do
    Path.wildcard("#{@posts_dir}/*.html")
    |> Enum.map(&Path.basename/1)
  end

  def compile_page(source_file, output_directory, opts \\ []) do
    with {:ok, html} <- File.read("#{@posts_dir}/#{source_file}") do
      basename = Path.basename(source_file) |> String.split(".") |> hd()

      title =
        basename
        |> String.replace(~r/_|-/, " ")
        |> String.split(" ")
        |> Enum.map(&String.capitalize(&1))
        |> Enum.join(" ")

      file_contents = """
      <!DOCTYPE html>
      <html>
        <head>
        <title>Chris Bailey -- #{title}</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="stylesheet" href="#{naive_relative_to("assets/style.css", output_directory)}">
      </head>
      <body>
      #{header(output_directory)}
      #{html}
      #{footer()}
      </body>
      </html>
      """

      output_filename =
        "#{output_directory}/#{opts[:force_filename] || basename <> ".html"}"
        |> String.replace(~r/\/\//, "/")

      :ok = File.write(output_filename, file_contents)

      {output_filename, title}
    end
  end

  def compile_list(list_of_posts, output_directory, opts \\ []) do
    title = opts[:force_title] || "All Posts"

    contents =
      list_of_posts
      |> Enum.map(fn {filename, title} ->
        """
        <article>
          <a href="#{filename}">#{title}</a>
          <time datetime="TBA">Date to be implemented</time>
        </article>
        """
      end)
      |> Enum.join("\n")

    file_contents = """
    <!DOCTYPE html>
    <html>
      <head>
      <title>Chris Bailey -- #{title}</title>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">

      <link rel="stylesheet" href="#{naive_relative_to("assets/style.css", output_directory)}">
    </head>
    <body>
    #{header(output_directory)}
    <h1>#{title}</h1>
    #{contents}
    #{footer()}
    </body>
    </html>
    """

    output_filename =
      "#{output_directory}/#{opts[:force_filename]}"
      |> String.replace(~r/\/\//, "/")

    :ok = File.write(output_filename, file_contents)

    {output_filename, title}
  end

  defp footer() do
    """
    <footer>
      © 2017 - 2019 Chris Bailey
    </footer>
    """
  end

  defp header(cwd) do
    """
    <header>
      <p> Chris Bailey </p>
      <nav>
        <a href="#{naive_relative_to("./blog.html", cwd)}">Blog</a>
        <a href="#{naive_relative_to("./index.html", cwd)}">About</a>
      </nav>
    </header>
    """
  end

  defp naive_relative_to(path, from) do
    path_depth = path |> String.split("") |> Enum.count(&(&1 == "/"))
    from_depth = from |> String.split("") |> Enum.count(&(&1 == "/"))

    "#{0..(from_depth - path_depth) |> Enum.map(fn _ -> "." end) |> Enum.join()}/#{path}"
  end
end

# ==============================================#
# Script                                        #
# ==============================================#
:ok = S.init()
{_filename, _title} = S.compile_page("about_me.html", "./", force_filename: "index.html")

articles =
  S.list_posts()
  |> Enum.map(&S.compile_page(&1, "./blog/"))

{_filename, _title} = S.compile_list(articles, "./", force_filename: "blog.html")
