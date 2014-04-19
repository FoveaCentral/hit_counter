require File.dirname(__FILE__) + '/../spec_helper'

describe HitCounter do
  before :all do
    HitCounter.delete_all
    @hit_counter = HitCounter.get 'www.google.com'
  end

  describe '#get' do
    context 'when existing URL' do
      before { @hit_counter2 = HitCounter.get @hit_counter.url, 10 }

      describe 'document count' do
        it { expect(HitCounter.count).to eq 1 }
      end

      context 'with starting count 10' do
        describe 'hits' do
          it { expect(@hit_counter2.hits).to eq 10 }
        end
      end
    end

    context 'when new URL' do
      before { HitCounter.get 'www.cnn.com' }

      describe 'document count' do
        it { expect(HitCounter.count).to eq 2 }
      end

      context 'with blank starting count' do
        describe '#hits' do
          it { expect(HitCounter.get('www.nytimes.com', nil).hits).to eq 0 }
        end
      end

      context 'with starting count 10' do
        describe '#hits' do
          it { expect(HitCounter.get('online.wsj.com', 10).hits).to eq 10 }
        end
      end
    end
  end

  describe '#hits' do
    subject { @hit_counter.hits }

    it { expect(subject).to eq 0 }

    context 'when incremented' do
      before { @hit_counter.increment }

      it { expect(@hit_counter.hits).to eq 1 }
    end
  end

  describe '#image' do
    subject { @hit_counter.image '1' }

    it { expect(subject).to be_a Magick::Image }
  end

  describe '#normalize_style_number' do
    context 'when nil' do
      it { expect(HitCounter.normalize_style_number(nil)).to be_zero }
    end

    context 'when empty string' do
      it { expect(HitCounter.normalize_style_number('')).to be_zero }
    end

    context 'when within range' do
      it 'returns 0 for 1' do
        expect(HitCounter.normalize_style_number('1')).to eq 0
      end

      it 'returns 2 for 3' do
        expect(HitCounter.normalize_style_number('3')).to eq 2
      end
    end

    context 'when outside range' do
      context 'with negative' do
        context 'returns 2 for' do
          it -1 do
            expect(HitCounter.normalize_style_number('-1')).to eq 2
          end

          it -31 do
            expect(HitCounter.normalize_style_number('-31')).to eq 2
          end
        end
      end

      context 'with positive' do
        context 'returns 0 for' do
          it 4 do
            expect(HitCounter.normalize_style_number('4')).to eq 0
          end

          it 34 do
            expect(HitCounter.normalize_style_number('34')).to eq 0
          end
        end
      end
    end
  end

  describe '#normalize_url' do
    context 'with "cnn.com"' do
      it { expect(HitCounter.normalize_url('cnn.com')).to eq 'http://cnn.com' }
    end

    context 'with "http://www.nytimes.com"' do
      it { expect(HitCounter.normalize_url('http://www.nytimes.com')).to eq 'http://www.nytimes.com' }
    end
  end
end