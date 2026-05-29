class ProductSearchService
  def initialize(company, query)
    @company = company
    @query = query.to_s.strip
  end

  def call
    return Product.none if @query.blank?

    base_scope = Product.where(company: @company).active

    if @query.length >= 3
      base_scope.full_text_search(@query)
    else
      base_scope.where(
        "internal_code ILIKE :q OR sku ILIKE :q",
        q: "#{@query}%"
      )
    end
  end
end
