require "holt_winters_aberrations/math"
require "holt_winters_aberrations/multiplicative_forecaster"
require "holt_winters_aberrations/version"

module HoltWintersAberrations
  def forecast(data:)
    MultiplicitiveForecaster.new(data: data)
  end
end
