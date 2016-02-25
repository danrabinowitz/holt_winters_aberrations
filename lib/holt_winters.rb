require "holt_winters/math"
require "holt_winters/multiplicative_forecaster"
require "holt_winters/version"

module HoltWinters
  def forecast(data:)
    MultiplicitiveForecaster.new(data: data)
  end
end
