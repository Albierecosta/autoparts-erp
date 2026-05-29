import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]

  connect() {
    this.debounceTimer = null
  }

  search() {
    clearTimeout(this.debounceTimer)
    const q = this.inputTarget.value.trim()

    if (q.length < 2) {
      this.resultsTarget.classList.add("hidden")
      return
    }

    this.debounceTimer = setTimeout(() => this.doSearch(q), 300)
  }

  async doSearch(q) {
    try {
      const res = await fetch(`/search/products?q=${encodeURIComponent(q)}`, {
        headers: { "Accept": "application/json" }
      })
      const products = await res.json()
      this.renderResults(products)
    } catch (e) {
      console.error("Search error:", e)
    }
  }

  renderResults(products) {
    if (products.length === 0) {
      this.resultsTarget.innerHTML = '<p class="p-3 text-sm text-gray-500">Nenhum produto encontrado</p>'
    } else {
      this.resultsTarget.innerHTML = products.map(p => `
        <a href="/products/${p.id}" class="block px-3 py-2 hover:bg-gray-50 dark:hover:bg-gray-700 border-b border-gray-100 dark:border-gray-700 last:border-0">
          <div class="flex justify-between items-center">
            <div>
              <p class="text-sm font-medium text-gray-900 dark:text-white">${p.name}</p>
              <p class="text-xs text-gray-500">${p.internal_code || ""} ${p.brand ? "· " + p.brand : ""}</p>
            </div>
            <div class="text-right">
              <p class="text-sm font-semibold text-green-600">R$ ${Number(p.sale_price).toFixed(2)}</p>
              <p class="text-xs text-gray-500">Estoque: ${p.stock_quantity}</p>
            </div>
          </div>
        </a>
      `).join("")
    }
    this.resultsTarget.classList.remove("hidden")
  }

  navigate(event) {
    if (event.key === "Escape") {
      this.resultsTarget.classList.add("hidden")
    }
  }

  hideResults(event) {
    if (!this.element.contains(event.target)) {
      this.resultsTarget.classList.add("hidden")
    }
  }

  connect() {
    this.boundHide = this.hideResults.bind(this)
    document.addEventListener("click", this.boundHide)
  }

  disconnect() {
    document.removeEventListener("click", this.boundHide)
  }
}
