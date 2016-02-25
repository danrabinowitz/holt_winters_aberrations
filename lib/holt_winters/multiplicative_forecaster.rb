module HoltWinters
  class MultiplicativeForecaster
    def initialize(data:, α:, s:)
      @data = data
      @α = α
      @s = s
      # @level = Hash.new{ |h,k| h[k] = k < s ? k : h[k-1] + h[k-2] }
    end

    def level(t)
      α * data(t) / seasonal(t-s) +
        (1 - α) * (level(t-1) + b(t - 1))
    end

    def seasonal(t)
      if t < s
        data(t) / level_s
      else
        raise NotImplementedError
        γ
      end
    end

    # Initial values
    def level_s # L_t
      Math.mean(@data[0..(s-1)])
    end

    def trend_s # t_b
      (@data[s-1] - @data[0]).to_r / (s-1)
      # (Math.sum(@data[s..(2*s-1)]) - 
      #   Math.sum(@data[0..(s-1)])).to_r / (s*s)
    end

    # # Multiplicative
    # def seasonal_s # S_t

    # end

    def α
      @α
    end

    def s
      @s
    end

    def data(t)
      @data[t]
    end
  end
end
