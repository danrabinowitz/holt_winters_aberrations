module HoltWinters
  module Math
    module_function

    def sum(items)
      items.inject(0, :+)
    end

    def mean(items)
      sum(items).to_r / items.length
    end
  end
end
