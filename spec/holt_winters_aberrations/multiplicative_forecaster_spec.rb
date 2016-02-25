require 'spec_helper'

describe HoltWintersAberrations::MultiplicativeForecaster do
  let(:forecaster) { HoltWintersAberrations::MultiplicativeForecaster.new(data: data, α: α, β: β, γ: γ, s: s) }

  describe "known data" do
    let(:data) { [112,118,132,129,121,135,148,148,136,119,104,118,115,126,141,135,125,149,170,170,158,133,114,140,145,150,178,163,172,178,199,199,184,162,146,166] }
    let(:α) { 0.513919299390167 }
    let(:β) { 0.0614806126715019 }
    let(:γ) { 0 }
    let(:s) { 12 }

    describe "level_s" do
      it "returns the known value" do
        expect(forecaster.level_s).to eq(380/3.to_r)
      end
    end

    describe "trend_s" do
      it "returns the known value" do
        warn "WARNING: This matches the Excel data, but not the formula I'm using."
        expect(forecaster.trend_s).to eq(6.to_r/11)
      end
    end

    describe "seasonal" do
      describe "initial values" do
        it "returns the known values" do
          warn "WARNING: This matches the Excel data, but not the formula I'm using."
          expect(forecaster.seasonal(0)).to eq(84/95.to_r)
          expected_data = [0.88,0.93,1.04,1.02,0.96,1.07,1.17,1.17,1.07,0.94,0.82,0.93]
          expect((0..11).to_a.map{|i| forecaster.seasonal(i).round(2) }).to eq(expected_data)
        end
      end

      describe "all values" do
        it "returns the known values" do
          expected_values = [0.88,0.93,1.04,1.02,0.96,1.07,1.17,1.17,1.07,0.94,0.82,0.93,0.88,0.93,1.04,1.02,0.96,1.07,1.17,1.17,1.07,0.94,0.82,0.93,0.88,0.93,1.04,1.02,0.96,1.07,1.17,1.17,1.07,0.94,0.82,0.93,0.88,0.93,1.04,1.02,0.96,1.07,1.17,1.17,1.07,0.94,0.82,0.93,0.88,0.93,1.04,1.02,0.96,1.07,1.17,1.17,1.07,0.94,0.82]
          calculated_values = (0..(expected_values.size - 1)).to_a.map{ |i| forecaster.seasonal(s+i).round(2) }
          expect(calculated_values).to eq(expected_values)
        end
      end
    end

    describe "level" do
      it "returns the known values" do
        expected_values = [128.68,132.37,134.28,133.83,132.69,136.68,141.64,144.18,146.31,144.49,142.12,146.74,156.15,159.44,166.12,163.99,173.10,171.05,171.63,171.86,172.47,173.28,176.42,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17]
        calculated_values = (0..(expected_values.size - 1)).to_a.map{ |i| forecaster.level(s+i).round(2) }
        expect(calculated_values).to eq(expected_values)
      end
    end

    describe "trend" do
      it "returns the known values" do
        expected_values = [0.55,0.55,0.55,0.55,0.55,0.55,0.55,0.55,0.55,0.55,0.55,0.55,0.64,0.82,0.89,0.81,0.69,0.89,1.14,1.23,1.28,1.09,0.88,1.11,1.62,1.72,2.03,1.77,2.22,1.96,1.87,1.77,1.70,1.65,1.74,1.74,1.74,1.74,1.74,1.74,1.74,1.74,1.74,1.74,1.74,1.74,1.74,1.74,1.74,1.74,1.74,1.74,1.74,1.74,1.74,1.74,1.74,1.74,1.74]
        calculated_values = (0..(expected_values.size - 1)).to_a.map{ |i| forecaster.trend(i).round(2) }
        expect(calculated_values).to eq(expected_values)
      end
    end

    describe "forecast" do
      it "returns the known values" do
        expected_values = [112.48,120.46,138.80,137.66,128.61,142.15,160.74,166.83,156.12,138.66,119.53,133.22,130.73,146.97,167.94,171.24,158.34,186.86,202.15,202.72,186.43,163.63,143.63,165.97,159.08,169.23,191.12,188.55,178.51,201.02,222.41,224.45,208.12,183.74,162.01,185.44,177.55,188.68,212.88,209.81,198.46,223.28,246.81,248.85,230.54,203.36,179.15,204.89]
        expect(forecaster.forecast(12)).to eq(117544/1045.to_r)
        calculated_values = (0..(expected_values.size - 1)).to_a.map{ |i| forecaster.forecast(s+i).to_f.round(2) }
        expect(calculated_values).to eq(expected_values)
      end
    end
  end



  describe "level_s" do
    describe "simple data" do
      let(:data) { [1, 6, -100] }
      let(:α) { nil }
      let(:β) { nil }
      let(:γ) { nil }
      let(:s) { 2 }

      it "returns the mean of the first s values" do
        expect(forecaster.level_s).to eq(7/2.to_r)
      end
    end
  end

  describe "level" do
    describe "minimal valid data" do
      let(:data) { [1,3,2,4] }
      let(:α) { nil }
      let(:β) { nil }
      let(:γ) { nil }
      let(:s) { 2 }

      it "returns a numeric value" do
        expect(forecaster.level(0)).to eq(2/1.to_r)
      end
    end
  end

  describe "forecast" do
    describe "weekly data" do
      let(:data) { (0..(24*7*10)).to_a.map{|t| h = t%24; val = 12-(h - 12).abs + 0.2; (val*val-1).round(1)} }
      let(:α) { 0.5 }
      let(:β) { 0.06 }
      let(:γ) { 0 }
      let(:s) { 24*7 }

      it "returns numeric values which are close to the real values" do
        calculated_values = (0..(data.size + 24 - 1)).to_a.map{ |i| forecaster.forecast(s+i).to_f.round(2) }
        expect((0..(data.size - s - 1)).to_a.map{ |i| calculated_values[i] - data[s+i] }.all?{|v| v.abs < 0.04}).to eq(true)
      end
    end

    describe "trivial data" do
      let(:data) { [1,1,1,1,] }
      let(:α) { 0 }
      let(:β) { 0 }
      let(:γ) { 0 }
      let(:s) { 2 }

      it "returns a numeric value" do
        expect(forecaster.forecast(2)).to eq(1)
        expect(forecaster.forecast(3)).to eq(1)
      end
    end

    describe "minimal valid data" do
      let(:data) { [1,2,2,1] }
      let(:α) { 0 }
      let(:β) { 0 }
      let(:γ) { 0 }
      let(:s) { 4 }

      it "returns a numeric value" do
        expect(forecaster.forecast(4)).to eq(1)
        expect(forecaster.forecast(5)).to eq(2)
      end
    end
  end

  describe "predicted deviation" do
    describe "minimal valid data" do
      let(:data) { [1,3,2,4,1,3,2,4] }
      let(:α) { 0 }
      let(:β) { 0 }
      let(:γ) { 0 }
      let(:s) { 4 }

      it "returns a numeric value" do
        expect(forecaster.predicted_deviation(4)).to eq(0)
        expect(forecaster.predicted_deviation(5)).to eq(0)
        expect(forecaster.predicted_deviation(6)).to eq(0)
        expect(forecaster.predicted_deviation(7)).to eq(0)
      end
    end
  end

  describe "aberration" do
    describe "no aberration" do
      let(:data) { [1,2,2,1, 1,2,2,1] }
      let(:α) { 0 }
      let(:β) { 0 }
      let(:γ) { 0 }
      let(:s) { 4 }

      it "returns a numeric value" do
        expect(forecaster.aberration(4)).to eq(0)
        expect(forecaster.aberration(5)).to eq(0)
        expect(forecaster.aberration(6)).to eq(0)
        expect(forecaster.aberration(7)).to eq(0)
      end
    end

    describe "one aberration" do
      let(:data) { [1,2,2,1, 1,2+7,2,1] }
      let(:α) { 0 }
      let(:β) { 0 }
      let(:γ) { 0 }
      let(:s) { 4 }

      it "returns a numeric value" do
        expect(forecaster.aberration(4)).to eq(0)
        expect(forecaster.aberration(5)).to eq(7)
        expect(forecaster.aberration(6)).to eq(0)
        expect(forecaster.aberration(7)).to eq(0)
      end
    end
  end

  describe "aberration_fraction" do
    describe "no aberration" do
      let(:data) { [1,2,2,1, 1,2,2,1] }
      let(:α) { 0 }
      let(:β) { 0 }
      let(:γ) { 0 }
      let(:s) { 4 }

      it "returns a numeric value" do
        expect(forecaster.aberration_fraction(4)).to eq(0)
        expect(forecaster.aberration_fraction(5)).to eq(0)
        expect(forecaster.aberration_fraction(6)).to eq(0)
        expect(forecaster.aberration_fraction(7)).to eq(0)
      end
    end
  end

  describe "small aberration" do
      let(:data) { [1,2,2,1, 1,2 + 0.01,2,1] }
      let(:α) { 0 }
      let(:β) { 0 }
      let(:γ) { 0 }
      let(:s) { 4 }

      it "returns a numeric value" do
        expect(forecaster.aberration_fraction(4)).to eq(0)
        expect(forecaster.aberration_fraction(5).round(3)).to eq(0.005)
        expect(forecaster.aberration_fraction(6)).to eq(0)
        expect(forecaster.aberration_fraction(7)).to eq(0)
      end
  end
end
