defmodule BlogWeb.Components.Nav do
  @moduledoc false

  use Phoenix.Component

  alias Phoenix.LiveView.JS

  alias BlogWeb.Components.Nav.Signature
  alias FontAwesome.LiveView, as: FontAwesome
  alias Heroicons.LiveView, as: Heroicons

  defmodule Link do
    @moduledoc false
    defstruct [:label, :icon, :href, :action, states: [], args: %{}, styles: ""]
  end

  def hide_sidebar(js \\ %JS{}) do
    js
    |> JS.remove_class("drop-shadow-xl", to: "#sidebar")
    |> JS.remove_class("pointer-events-none", to: "#root > *:not(#sidebar) > *")
    |> JS.remove_class("brightness-75", to: "#root > *:not(#sidebar)")
    |> JS.add_class("-translate-x-full", to: "#sidebar")
  end

  def show_sidebar(js \\ %JS{}) do
    js
    |> JS.add_class("drop-shadow-xl", to: "#sidebar")
    |> JS.add_class("pointer-events-none", to: "#root > *:not(#sidebar) > *")
    |> JS.add_class("brightness-75", to: "#root > *:not(#sidebar)")
    |> JS.remove_class("-translate-x-full", to: "#sidebar")
  end

  def sidebar(assigns) do
    local_links = [
      %Link{label: "About Me", icon: "finger-print", action: "select-about", states: [:about]},
      %Link{
        label: "Posts",
        icon: "folder-open",
        action: "select-index",
        states: [:post, :index],
        styles: "lg:hidden"
      },
      %Link{label: "Resume", icon: "document-text", href: "https://cbailey.co.uk/assets/cv.pdf"},
      %Link{label: "RSS", icon: "rss", href: "/rss"}
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
      h-full drop-shadow-0 -translate-x-full
      2xl:translate-x-0 2xl:relative 2xl:pt-0 2xl:border-r 2xl:transition-none 2xl:drop-shadow-none
    ">
      <nav class="w-full flex items-center p-4 space-x-4 font-semibold 2xl:justify-center 2xl:border-b">
        <div class="2xl:hidden cursor-pointer select-none" phx-click={hide_sidebar()}>
          <Heroicons.icon name="x" type="outline" class="h-4 w-4 shrink-0" />
        </div>
        <span class="2xl:hidden">Chris Bailey</span>
        <span class="hidden py-2 2xl:block cursor-pointer select-none">
          <%= Signature.svg("h-10 transform-gpu hover:scale-150 hover:text-rose-400 hover:-rotate-12 transition duration-200") %>
        </span>
      </nav>
      <div id="sidebar-links" class="flex flex-col px-4 space-y-0.5 mt-6">
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
      #{if @state in @link.states, do: "underline decoration-rose-400 hover:decoration-rose-400"}
      flex items-center space bg-white px-2 py-2.5 rounded-md text-sm justify-between
      hover:underline #{if @state not in @link.states, do: "hover:decoration-gray-400"}
      decoration-wavy underline-offset-4 cursor-pointer select-none #{@link.styles}
    "}>
      <span class="flex items-center space-x-2.5">
        <%= cond do %>
          <% is_nil(@link.icon) -> %>
            <Heroicons.icon name="link" type="outline" class="h-5 w-5" />
          <% assigns[:external] -> %>
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
    <nav phx-click={hide_sidebar()} class="
      2xl:hidden
      bg-white
      duration-300
      ease-in-out
      flex
      items-center
      justify-between
      md:border-b
      md:shadow-none
      p-4
      shadow-xl
      sticky
      top-0
      transform-gpu
      transition
      w-full
      z-40
    ">
      <.action_left state={@state} />
      <.title state={@state} title={@title} />
      <.action_right />
    </nav>
    """
  end

  def main(assigns) do
    ~H"""
    <main phx-click={hide_sidebar()} class="
      transition transform-gpu ease-in-out duration-300 grow overflow-hidden relative md:flex
    ">
      <%= render_slot(@inner_block) %>
    </main>
    """
  end

  def title(assigns) do
    ~H"""
    <div class={"cursor-pointer select-none #{@state == :post && "xs:block sm:block" || "hidden"} md:hidden"}>
      <span class="mx-2 line-clamp-1 text-center text-md font-bold"><%= @title %></span>
    </div>
    <div class={"cursor-pointer select-none #{@state in [:index, :about] && "xs:block sm:block" || "hidden"} md:block"} phx-click="select-about">
      <%= Signature.svg("transform-gpu hover:text-rose-400 hover:-rotate-12 transition duration-200 h-8") %>
    </div>
    """
  end

  def action_left(assigns) when assigns.state == :post do
    ~H"""
    <div class={"
      #{assigns[:class]}
      cursor-pointer
      select-none
    "} phx-click="select-index">
      <Heroicons.icon name="arrow-narrow-left" type="outline" class="h-4 w-4 shrink-0" />
    </div>
    """
  end

  def action_left(assigns) do
    ~H"""
    <div class={"
      #{assigns[:class]}
      cursor-pointer
      select-none
    "} phx-click={show_sidebar()}>
      <Heroicons.icon name="menu" type="outline" class="h-4 w-4" />
    </div>
    """
  end

  def action_right(assigns) do
    ~H"""
    <Heroicons.icon name="sun" type="outline" class={"
      h-4
      w-4
      shrink-0
      #{assigns[:class]}
    "}/>
    """
  end
end
