require 'spec_helper'

describe HoltWinters::MultiplicativeForecaster do
  let(:forecaster) { HoltWinters::MultiplicativeForecaster.new(data: data, α: α, β: β, s: s) }

  describe "known data" do
    let(:data) { [112,118,132,129,121,135,148,148,136,119,104,118,115,126,141,135,125,149,170,170,158,133,114,140,145,150,178,163,172,178,199,199,184,162,146,166] }
    let(:α) { 0.513919299390167 }
    let(:β) { 0.0614806126715019 }
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
          skip
        end
      end
    end

    describe "level" do
      it "returns the known values" do
        expected_values = [128.68,132.37,134.28,133.83,132.69,136.68,141.64,144.18,146.31,144.49,142.12,146.74,156.15,159.44,166.12,163.99,173.10,171.05,171.63,171.86,172.47,173.28,176.42,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17,178.17]
        expect(forecaster.level(12).round(2)).to eq(expected_values[0])
      end
    end

  describe "forecast" do
    it "returns the known values" do
      expect(forecaster.forecast(12)).to eq(117544/1045.to_r)
      # expect(forecaster.forecast(13)).to eq('foo')
    end
  end

  end



  describe "level_s" do
    describe "simple data" do
      it "returns the mean of the first s values" do
        data = [1, 6, -100]
        f = HoltWinters::MultiplicativeForecaster.new(data: data, α: 0.05, β: 0.01, s: 2)
        expect(f.level_s).to eq(7/2.to_r)
      end
    end

    # describe "known data" do
    #   it "returns the known value" do
    #     data = [112,118,132,129,121,135,148,148,136,119,104,118]
    #     f = HoltWinters::MultiplicativeForecaster.new(data: data, α: 0.05, s: 12)
    #     expect(f.level_s).to eq(380/3.to_r)
    #   end      
    # end
  end

  # describe "trend_s" do
  #   describe "known data" do
  #     it "returns the known value" do
  #       data = [112,118,132,129,121,135,148,148,136,119,104,118]
  #       f = HoltWinters::MultiplicativeForecaster.new(data: data, α: 0.05, s: 12)
  #       warn "WARNING: This matches the Excel data, but not the formula I'm using."
  #       expect(f.trend_s).to eq(6.to_r/11)
  #     end
  #   end
  # end

  # describe "seasonal" do
  #   describe "initial values" do
  #     describe "known data" do
  #       it "returns the known values" do
  #         data = [112,118,132,129,121,135,148,148,136,119,104,118]
  #         f = HoltWinters::MultiplicativeForecaster.new(data: data, α: 0.05, s: 12)
  #         warn "WARNING: This matches the Excel data, but not the formula I'm using."
  #         expect(f.seasonal(0)).to eq(84/95.to_r)
  #         expected_data = [0.88,0.93,1.04,1.02,0.96,1.07,1.17,1.17,1.07,0.94,0.82,0.93]
  #         expect((0..11).to_a.map{|i| f.seasonal(i).round(2) }).to eq(expected_data)
  #       end
  #     end
  #   end
  # end

  describe "level" do
    # describe "known data" do
    #   it "returns the known value" do
    #     skip
    #     data = [112,118,132,129,121,135,148,148,136,119,104,118]
    #     f = HoltWinters::MultiplicativeForecaster.new(data: data, α: 0.05, s: 12)
    #     warn "WARNING: This matches the Excel data, but not the formula I'm using."
    #     expect(f.level(12)).to eq("f00")
    #   end
    # end

    describe "minimal valid data" do
      it "returns a numeric value" do
        skip
        data = [1,3,2,4]
        f = HoltWinters::MultiplicativeForecaster.new(data: data, α: 0.05)
        expect(f.level(0)).to eq('foo')
      end
    end
  end

  # describe "forecast" do
  #   describe "known data" do
  #     it "returns the known value" do
  #       data = [112,118,132,129,121,135,148,148,136,119,104,118,115,126,141,135,125,149,170,170,158,133,114,140,145,150,178,163,172,178,199,199,184,162,146,166]
  #       f = HoltWinters::MultiplicativeForecaster.new(data: data, α: 0.05, s: 12)
  #       warn "WARNING: This matches the Excel data, but not the formula I'm using."
  #       expect(f.forecast(12)).to eq(117544/1045.to_r)
  #       expect(f.forecast(13)).to eq('foo')
  #     end
  #   end
  # end

end
