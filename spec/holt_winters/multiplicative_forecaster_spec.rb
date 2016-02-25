require 'spec_helper'

describe HoltWinters::MultiplicativeForecaster do
  describe "level_s" do
    describe "simple data" do
      it "returns the mean of the first s values" do
        data = [1, 6, -100]
        f = HoltWinters::MultiplicativeForecaster.new(data: data, α: 0.05, s: 2)
        expect(f.level_s).to eq(7/2.to_r)
      end
    end

    describe "known data" do
      it "returns the known value" do
        data = [112,118,132,129,121,135,148,148,136,119,104,118]
        f = HoltWinters::MultiplicativeForecaster.new(data: data, α: 0.05, s: 12)
        expect(f.level_s).to eq(380/3.to_r)
      end      
    end
  end

  describe "trend_s" do
    describe "known data" do
      it "returns the known value" do
        data = [112,118,132,129,121,135,148,148,136,119,104,118]
        f = HoltWinters::MultiplicativeForecaster.new(data: data, α: 0.05, s: 12)
        warn "WARNING: This matches the Excel data, but not the formula I'm using."
        expect(f.trend_s).to eq(6.to_r/11)
      end
    end
  end

  describe "seasonal" do
    describe "initial values" do
      describe "known data" do
        it "returns the known values" do
          data = [112,118,132,129,121,135,148,148,136,119,104,118]
          f = HoltWinters::MultiplicativeForecaster.new(data: data, α: 0.05, s: 12)
          warn "WARNING: This matches the Excel data, but not the formula I'm using."
          expect(f.seasonal(0)).to eq(84/95.to_r)
          expected_data = [0.88,0.93,1.04,1.02,0.96,1.07,1.17,1.17,1.07,0.94,0.82,0.93]
          expect((0..11).to_a.map{|i| f.seasonal(i).round(2) }).to eq(expected_data)
        end
      end
    end
  end

  describe "level" do
    describe "minimal valid data" do
      it "returns a numeric value" do
        skip
        data = [1,3,2,4]
        f = HoltWinters::MultiplicativeForecaster.new(data: data, α: 0.05)
        expect(f.level(0)).to eq('foo')
      end
    end
  end
end
