import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "itemsContainer", "itemRow", "itemCount", "emptyMsg",
    "productId", "qty", "unitPrice", "itemTotal", "itemName", "itemCode", "destroy",
    "subtotal", "discount", "total",
    "discountPercent", "discountAmount",
    "statusField"
  ]

  connect() {
    // Escuta evento do product-search-sale (comunicação via evento customizado)
    this.boundAddFromEvent = this.addFromEvent.bind(this)
    this.element.addEventListener("product-search-sale:selected", this.boundAddFromEvent)

    this.updateItemCount()
    this.updateEmptyState()
    this.recalculate()
  }

  disconnect() {
    this.element.removeEventListener("product-search-sale:selected", this.boundAddFromEvent)
  }

  // Recebe produto via evento customizado
  addFromEvent(event) {
    this.addProduct(event.detail.product)
  }

  addProduct(product) {
    const template = document.getElementById("sale-item-template")
    if (!template) {
      console.error("Template de item não encontrado (#sale-item-template)")
      return
    }

    const content = template.innerHTML.replace(/ITEM_INDEX/g, Date.now())
    const div = document.createElement("div")
    div.innerHTML = content.trim()
    const row = div.firstElementChild
    if (!row) {
      console.error("Template gerou linha vazia")
      return
    }

    const pid   = row.querySelector("[data-sale-form-target='productId']")
    const qty   = row.querySelector("[data-sale-form-target='qty']")
    const price = row.querySelector("[data-sale-form-target='unitPrice']")
    const name  = row.querySelector("[data-sale-form-target='itemName']")
    const code  = row.querySelector("[data-sale-form-target='itemCode']")

    if (pid)   pid.value   = product.id
    if (qty)   qty.value   = 1
    if (price) price.value = parseFloat(product.sale_price || 0).toFixed(2)
    if (name)  name.textContent  = product.name || "Produto"
    if (code)  code.textContent  = product.internal_code || ""

    this.itemsContainerTarget.appendChild(row)

    this.updateItemCount()
    this.recalculate()
    this.updateEmptyState()
  }

  removeItem(event) {
    const row = event.target.closest("[data-sale-form-target='itemRow']")
    if (!row) return

    const destroyField = row.querySelector("[data-sale-form-target='destroy']")
    const productId    = row.querySelector("[data-sale-form-target='productId']")?.value

    if (destroyField && productId) {
      destroyField.value = "1"
      row.style.display = "none"
    } else {
      row.remove()
    }

    this.updateItemCount()
    this.recalculate()
    this.updateEmptyState()
  }

  increaseQty(event) {
    const row = event.target.closest("[data-sale-form-target='itemRow']")
    const qtyField = row?.querySelector("[data-sale-form-target='qty']")
    if (!qtyField) return
    qtyField.value = parseInt(qtyField.value || 1) + 1
    this.recalculate()
  }

  decreaseQty(event) {
    const row = event.target.closest("[data-sale-form-target='itemRow']")
    const qtyField = row?.querySelector("[data-sale-form-target='qty']")
    if (!qtyField) return
    const current = parseInt(qtyField.value || 1)
    if (current > 1) {
      qtyField.value = current - 1
      this.recalculate()
    }
  }

  recalculate() {
    let subtotal = 0
    this.itemsContainerTarget
      .querySelectorAll("[data-sale-form-target='itemRow']")
      .forEach(row => {
        if (row.style.display === "none") return
        const qty   = parseFloat(row.querySelector("[data-sale-form-target='qty']")?.value || 0)
        const price = parseFloat(row.querySelector("[data-sale-form-target='unitPrice']")?.value || 0)
        const lineTotal = qty * price
        subtotal += lineTotal
        const el = row.querySelector("[data-sale-form-target='itemTotal']")
        if (el) el.textContent = `R$ ${lineTotal.toFixed(2)}`
      })

    const discountPct = parseFloat(this.hasDiscountPercentTarget ? this.discountPercentTarget.value : 0)
    const discountAmt = parseFloat(this.hasDiscountAmountTarget ? this.discountAmountTarget.value : 0)
    const discount    = discountAmt > 0 ? discountAmt : (subtotal * discountPct / 100)
    const total       = Math.max(subtotal - discount, 0)

    if (this.hasSubtotalTarget) this.subtotalTarget.textContent = `R$ ${subtotal.toFixed(2)}`
    if (this.hasDiscountTarget) this.discountTarget.textContent = `- R$ ${discount.toFixed(2)}`
    if (this.hasTotalTarget)    this.totalTarget.textContent    = `R$ ${total.toFixed(2)}`
  }

  updateItemCount() {
    const count = this.visibleItemCount()
    if (this.hasItemCountTarget) this.itemCountTarget.textContent = `${count} item(s)`
  }

  updateEmptyState() {
    const empty = this.visibleItemCount() === 0
    if (this.hasEmptyMsgTarget) this.emptyMsgTarget.style.display = empty ? "block" : "none"
  }

  visibleItemCount() {
    return [...this.itemsContainerTarget.querySelectorAll("[data-sale-form-target='itemRow']")]
      .filter(r => r.style.display !== "none").length
  }

  saveAsPending() {
    if (this.hasStatusFieldTarget) this.statusFieldTarget.value = "pending"
    this.element.requestSubmit()
  }
}
