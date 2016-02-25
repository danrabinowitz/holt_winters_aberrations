module HoltWinters
  class MultiplicativeForecaster
    def initialize(data:, α:, β:, s:)
      @data = data
      @α = α
      @s = s
      @β = β
      # @level = Hash.new{ |h,k| h[k] = k < s ? k : h[k-1] + h[k-2] }
    end

    def forecast(t)
      if t < s
        raise NotImplementedError, "forecast only works for periods after s"
      else
        (level(t-1) + horizon(t-1) * trend(t-1)) * seasonal(t-s)
      end
    end

    def level(t)
      if t < s
        level_s
      else
        α * data(t) / seasonal(t-s) + (1 - α) * (level(t-1) + trend(t - 1))
      end
    end

    def horizon(t)
      if t < @data.size
        1
      else
        t - @data.size + 2
      end
    end

    def seasonal(t)
      if t < s
        data(t) / level_s
      else
        raise NotImplementedError
        γ
      end
    end

    def trend(t)
      if t < s
        trend_s
      else
        β * (level(t) - level(t-1)) + (1-β) * trend(t-1)
      end
    end

    # Initial values
    def level_s # L_t
      Math.mean(@data[0..(s-1)])
    end

    def trend_s # b_t
      (@data[s-1] - @data[0]).to_r / (s-1)
    end

    def α
      @α
    end

    def β
      @β
    end

    def s
      @s
    end

    def data(t)
      @data[t]
    end
  end
end
