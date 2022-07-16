defmodule BlogWeb.Components.Nav do
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  alias BlogWeb.Components.Nav.Signature
  alias Heroicons.LiveView, as: Heroicons
  alias FontAwesome.LiveView, as: FontAwesome

  defmodule Link do
    defstruct [:label, :icon, :state, :href, :action, args: %{}]
  end

  def hide_sidebar(js \\ %JS{}) do
    js
    |> JS.remove_class("pointer-events-none", to: "#root *")
    |> JS.remove_class("brightness-75", to: "#root")
    |> JS.add_class("-translate-x-full", to: "#sidebar")
  end

  def show_sidebar(js \\ %JS{}) do
    js
    |> JS.add_class("pointer-events-none", to: "#root *")
    |> JS.add_class("brightness-75", to: "#root")
    |> JS.remove_class("-translate-x-full", to: "#sidebar")
  end

  def sidebar(assigns) do
    local_links = [
      %Link{label: "About Me", icon: "finger-print", action: "select-about", state: :about},
      %Link{label: "Posts", icon: "folder-open", action: "select-index", state: :index},
      %Link{label: "CV", icon: "document-text", href: "https://cbailey.co.uk/assets/cv.pdf"}
    ]

    remote_links = [
      %Link{label: "GitHub", icon: "github", href: "https://github.com/vereis"},
      %Link{label: "Twitter", icon: "twitter", href: "https://twitter.com/yiiniiniin"},
      %Link{label: "LinkedIn", icon: "linkedin", href: "https://linkedin.com/in/yiiniiniin"}
    ]

    project_links = [
      %Link{label: "EctoHooks", href: "https://github.com/vereis/ecto_hooks"},
      %Link{label: "Sibyl", href: "https://github.com/vetspire/sibyl"}
    ]

    ~H"""
    <div id="sidebar" class="
      absolute transition transform-gpu ease-in-out duration-300 z-50 bg-white w-72
      h-full drop-shadow-xl -translate-x-full
    ">
      <nav class="w-full flex items-center p-4 space-x-4 font-semibold">
        <.close/>
        <span class="">Chris Bailey</span>
      </nav>
      <div class="flex flex-col px-4 space-y-0.5 mt-6">
        <%= for link <- local_links do %>
          <.sidebar_link state={@state} link={link} />
        <% end %>
        <span class="px-2 pt-6 pb-1.5 text-sm font-semibold text-gray-500">External</span>
        <%= for link <- remote_links do %>
          <.sidebar_link state={@state} link={link} external={true} />
        <% end %>
        <span class="px-2 pt-6 pb-1.5 text-sm font-semibold text-gray-500">Projects & Work</span>
        <%= for link <- project_links do %>
          <.sidebar_link state={@state} link={link} external={true} />
        <% end %>
      </div>
    </div>
    """
  end

  def sidebar_link(assigns) do
    ~H"""
    <a href={@link.href} phx-click={@link.action && JS.push(hide_sidebar(), @link.action, value: @link.args)} class={"
      #{if @state == @link.state, do: "underline decoration-wavy decoration-rose-400 underline-offset-4"}
      flex items-center space bg-white px-2 py-2.5 rounded-md text-sm justify-between
    "}>
      <span class="flex items-center space-x-2.5">
        <%= cond do %>
          <% is_nil(@link.icon) -> %>
            <Heroicons.icon name="link" type="outline" class="h-5 w-5" />
          <%= assigns[:external] -> %>
            <FontAwesome.icon name={@link.icon} type="brands" class="h-5 w-5" />
          <% true -> %>
            <Heroicons.icon name={@link.icon} type="outline" class="h-5 w-5" />
        <% end %>
        <span><%= @link.label %></span>
      </span>
      <%= if assigns[:external] do %>
        <Heroicons.icon name="arrow-up" type="outline" class="h-3 w-3 rotate-45 text-gray-500" />
      <% end %>
    </a>
    """
  end

  def bar(assigns) do
    ~H"""
    <nav class="
      sticky top-0 w-full flex items-center justify-between p-4 bg-white
      drop-shadow-xl z-40
    ">
      <%= if @state in [:about, :index] do%>
        <.about />
      <% else %>
        <.back />
      <% end %>
      <%= if @state == :post && not @show_logo do %>
        <div class="mx-2 line-clamp-1 text-center text-md font-bold"><%= @title %></div>
      <% else %>
        <.logo />
      <% end %>
      <.action />
    </nav>
    """
  end

  def main(assigns) do
    ~H"""
    <main class="bg-pink-100 grow overflow-hidden relative">
      <%= render_slot(@inner_block) %>
    </main>
    """
  end

  def logo(assigns) do
    ~H"""
    <div phx-click="select-about" class="-mb-2">
      <%= Signature.svg() %>
    </div>
    """
  end

  def close(assigns) do
    ~H"""
    <div phx-click={hide_sidebar()}>
      <Heroicons.icon name="x" type="outline" class="h-4 w-4 shrink-0" />
    </div>
    """
  end

  def back(assigns) do
    ~H"""
    <div phx-click="select-index">
      <Heroicons.icon name="arrow-narrow-left" type="outline" class="h-4 w-4 shrink-0" />
    </div>
    """
  end

  def about(assigns) do
    ~H"""
    <div phx-click={show_sidebar()}>
      <Heroicons.icon name="menu" type="outline" class="h-4 w-4" />
    </div>
    """
  end

  def action(assigns) do
    ~H"""
    <Heroicons.icon name="sun" type="outline" class="h-4 w-4 shrink-0" />
    """
  end
end
