import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["query", "results"]

  connect() {
    this.timer = null
    this.boundHide = this.hideResults.bind(this)
    document.addEventListener("click", this.boundHide)
  }

  disconnect() {
    document.removeEventListener("click", this.boundHide)
    clearTimeout(this.timer)
  }

  search() {
    clearTimeout(this.timer)
    const q = this.queryTarget.value.trim()
    if (q.length < 2) {
      this.hide()
      return
    }
    this.timer = setTimeout(() => this.doSearch(q), 250)
  }

  async doSearch(q) {
    try {
      const res = await fetch(`/search/products?q=${encodeURIComponent(q)}`, {
        headers: { "Accept": "application/json", "X-Requested-With": "XMLHttpRequest" }
      })
      if (!res.ok) throw new Error(`HTTP ${res.status}`)
      const products = await res.json()
      this.renderResults(products)
    } catch (e) {
      console.error("Erro na busca de produto:", e)
      this.resultsTarget.innerHTML = '<p class="p-3 text-sm text-red-500 text-center">Erro ao buscar. Tente novamente.</p>'
      this.resultsTarget.classList.remove("hidden")
    }
  }

  renderResults(products) {
    if (products.length === 0) {
      this.resultsTarget.innerHTML = '<p class="p-3 text-sm text-gray-500 text-center">Nenhum produto encontrado</p>'
    } else {
      this.resultsTarget.innerHTML = products.map(p => `
        <button type="button"
          class="w-full flex items-center justify-between px-4 py-3 hover:bg-blue-50 dark:hover:bg-blue-900/20 border-b border-gray-100 dark:border-gray-700 last:border-0 text-left transition-colors"
          data-action="click->product-search-sale#selectProduct"
          data-product-id="${p.id}"
          data-product-name="${this.escapeHtml(p.name)}"
          data-product-code="${this.escapeHtml(p.internal_code || '')}"
          data-product-price="${p.sale_price}"
          data-product-stock="${p.stock_quantity}">
          <div>
            <p class="text-sm font-medium text-gray-900 dark:text-white">${this.escapeHtml(p.name)}</p>
            <p class="text-xs text-gray-500">${this.escapeHtml(p.internal_code || '')} ${p.brand ? '· ' + this.escapeHtml(p.brand) : ''}</p>
          </div>
          <div class="text-right ml-4 flex-shrink-0">
            <p class="text-sm font-bold text-green-600">R$ ${Number(p.sale_price).toFixed(2)}</p>
            <p class="text-xs ${p.stock_quantity <= 0 ? 'text-red-500' : 'text-gray-500'}">Estoque: ${p.stock_quantity}</p>
          </div>
        </button>
      `).join("")
    }
    this.resultsTarget.classList.remove("hidden")
  }

  selectProduct(event) {
    const btn = event.currentTarget
    const product = {
      id:            btn.dataset.productId,
      name:          btn.dataset.productName,
      internal_code: btn.dataset.productCode,
      sale_price:    btn.dataset.productPrice,
      stock_quantity: btn.dataset.productStock
    }

    // Dispatch evento customizado — sale_form_controller escuta
    this.element.dispatchEvent(
      new CustomEvent("product-search-sale:selected", {
        bubbles: true,
        detail: { product }
      })
    )

    this.queryTarget.value = ""
    this.hide()
    this.queryTarget.focus()
  }

  handleKey(event) {
    if (event.key === "Escape") this.hide()
  }

  hide() {
    this.resultsTarget.classList.add("hidden")
    this.resultsTarget.innerHTML = ""
  }

  hideResults(event) {
    if (!this.element.contains(event.target)) this.hide()
  }

  escapeHtml(str) {
    return String(str)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
  }
}
