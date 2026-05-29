module ApplicationHelper
  include Pagy::Frontend

  # Override pagy_nav to render a simple Tailwind-styled nav instead of Bootstrap
  def pagy_nav(pagy, **vars)
    return "" unless pagy.pages > 1

    html = '<nav class="flex items-center gap-1">'

    if pagy.prev
      html += link_to("←", url_for(page: pagy.prev), class: "px-3 py-1.5 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors")
    end

    pagy.series.each do |item|
      if item.is_a?(Integer)
        html += link_to(item, url_for(page: item), class: "px-3 py-1.5 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors")
      elsif item.is_a?(String)
        html += "<span class='px-3 py-1.5 text-sm font-medium bg-blue-600 text-white rounded-lg'>#{item}</span>"
      elsif item == :gap
        html += "<span class='px-2 text-gray-400'>…</span>"
      end
    end

    if pagy.next
      html += link_to("→", url_for(page: pagy.next), class: "px-3 py-1.5 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors")
    end

    html += '</nav>'
    html.html_safe
  end

  def stock_badge_class(product)
    case product.stock_status
    when :out_of_stock then "bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400"
    when :low_stock    then "bg-orange-100 text-orange-800 dark:bg-orange-900/30 dark:text-orange-400"
    else                    "bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400"
    end
  end

  def sale_status_badge(status)
    case status
    when "confirmed"  then "bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400"
    when "pending"    then "bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400"
    when "cancelled"  then "bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400"
    else "bg-gray-100 text-gray-800"
    end
  end

  def financial_status_badge(status)
    case status
    when "paid"       then "bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400"
    when "pending"    then "bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400"
    when "cancelled"  then "bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400"
    else "bg-gray-100 text-gray-800"
    end
  end

  def money(amount)
    "R$ #{number_with_precision(amount.to_f, precision: 2, delimiter: ".", separator: ",")}"
  end
end
