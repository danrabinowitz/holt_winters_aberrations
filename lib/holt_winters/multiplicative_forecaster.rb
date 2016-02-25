module HoltWinters
  class MultiplicativeForecaster
    def initialize(data:, α:, β:, γ:, s:)
      @data = data
      @α = α
      @s = s
      @β = β
      @γ = γ
      # @level = Hash.new{ |h,k| h[k] = k < s ? k : h[k-1] + h[k-2] }

      @level = {}
      @trend = {}
      @seasonal = {}
    end

    attr_reader :α, :β, :γ, :s

    def forecast(t)
      if t < s
        raise NotImplementedError, "forecast only works for periods after s"
      else
        (level(t-1) + horizon(t-1) * trend(t-1)) * seasonal(t-s)
      end
    end

    def level(t)
      @level[t] ||= if t < s
        level_s
      elsif t >= @data.size
          level(@data.size-1)
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
      @seasonal[t] ||= if t < s
        data(t) / level_s
      elsif t >= @data.size
          seasonal(t-s)
      else
        γ * data(t) / level(t) + (1-γ) * seasonal(t - s)
      end
    end

    def trend(t)
      @trend[t] ||= if t < s
        trend_s
      elsif t >= @data.size
          trend(@data.size-1)
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

    def data(t)
      @data[t] || raise("Attempt to access data at t=#{t}, but it is empty")
    end
  end
end
