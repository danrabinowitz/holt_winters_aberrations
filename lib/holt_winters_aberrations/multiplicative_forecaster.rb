module HoltWintersAberrations
  class MultiplicativeForecaster
    def initialize(data:, α:, β:, γ:, s:)
      @data = data
      @α = α
      @s = s
      @β = β
      @γ = γ
      # @level = Hash.new{ |h,k| h[k] = k < s ? k : h[k-1] + h[k-2] }

      @forecast = {}
      @level = {}
      @trend = {}
      @seasonal = {}
      @predicted_deviation = {}
    end

    attr_reader :α, :β, :γ, :s

    def forecast(t)
      @forecast[t] ||= if t < s
        raise NotImplementedError, "forecast only works for periods after s"
      else
        (level(t-1) + horizon(t-1) * trend(t-1)) * seasonal(t-s)
      end
    end

    def predicted_deviation(t)
      @predicted_deviation[t] ||= if t < s
        0
      else
        γ * (data(t) - forecast(t)).abs + (1 - γ)*predicted_deviation(t - s)
      end
    end

    def scaled_deviation(t, delta: 3)
      predicted_deviation(t) * delta
    end

    def aberration(t, delta: 3)
      raise NotImplementedError, "aberration only works for periods after s" if t < s

      upper_bound = forecast(t) + scaled_deviation(t, delta: delta)
      lower_bound = forecast(t) - scaled_deviation(t, delta: delta)
      if data(t) > upper_bound
        data(t) - upper_bound
      elsif data(t) < lower_bound
        data(t) - lower_bound
      else
        0
      end
    end

    def aberration_fraction(t, delta: 3)
      raise NotImplementedError, "aberration only works for periods after s" if t < s

      scale = [forecast(t).abs, 1/1000].max
      aberration(t, delta: delta) / scale
    end

    def aberration?(t, delta: 3, cutoff: 0.1)
      aberration_fraction(t, delta: delta) > cutoff
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
