import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["costPrice", "salePrice", "margin"]

  calculateMargin() {
    const cost = parseFloat(this.costPriceTarget?.value || 0)
    const sale = parseFloat(this.salePriceTarget?.value || 0)

    if (cost > 0 && sale > 0) {
      const margin = ((sale - cost) / cost * 100).toFixed(1)
      this.marginTarget.textContent = `${margin}%`
      this.marginTarget.className = `text-sm font-semibold ${parseFloat(margin) >= 0 ? "text-green-600 dark:text-green-400" : "text-red-600"}`
    } else {
      this.marginTarget.textContent = "--"
    }
  }
}
