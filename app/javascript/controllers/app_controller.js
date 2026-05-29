import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.applyTheme()
  }

  toggleDarkMode() {
    const html = document.getElementById("html-root")
    const isDark = html.classList.contains("dark")
    html.classList.toggle("dark", !isDark)
    localStorage.setItem("theme", isDark ? "light" : "dark")
  }

  applyTheme() {
    const theme = localStorage.getItem("theme")
    const html = document.getElementById("html-root")
    if (theme === "dark" || (!theme && window.matchMedia("(prefers-color-scheme: dark)").matches)) {
      html.classList.add("dark")
    }
  }

  toggleSidebar() {
    const sidebar = document.getElementById("sidebar")
    sidebar?.classList.toggle("hidden")
  }
}
