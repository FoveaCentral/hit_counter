require File.dirname(__FILE__) + '/../spec_helper'

describe HitCounter do
  before :all do
    HitCounter.delete_all
    @hit_counter = HitCounter.get 'www.google.com'
  end

  describe '#get' do
    context 'when existing URL' do
      describe 'document count' do
        specify { HitCounter.count.should == 1 }
      end
    end

    context 'when new URL' do
      before { HitCounter.get 'www.cnn.com' }

      describe 'document count' do
        specify { HitCounter.count.should == 2 }
      end
    end
  end

  describe '#hits' do
    subject { @hit_counter.hits }

    it { should == 0 }

    context 'when incremented' do
      before { @hit_counter.increment }

      specify { @hit_counter.hits.should == 1 }
    end
  end

  describe '#image' do
    subject { @hit_counter.image '1' }

    it { should be_a Magick::Image }
    pending 'should reflect hits'
  end

  describe '#normalize_style_number' do
    context 'when undefined' do
      it 'should return 0' do
        HitCounter.normalize_style_number(nil).should == 0
      end
    end

    context 'when within range' do
      it 'should return 0 for 1' do
        HitCounter.normalize_style_number('1').should == 0
      end

      it 'should return 2 for 3' do
        HitCounter.normalize_style_number('3').should == 2
      end
    end

    context 'when outside range' do
      context 'and negative' do
        context 'should return 2 for' do
          it -1 do
            HitCounter.normalize_style_number('-1').should == 2
          end

          it -31 do
            HitCounter.normalize_style_number('-31').should == 2
          end
        end
      end

      context 'and positive' do
        context 'should return 0 for' do
          it 4 do
            HitCounter.normalize_style_number('4').should == 0
          end

          it 34 do
            HitCounter.normalize_style_number('34').should == 0
          end
        end
      end
    end
  end

  describe '#normalize_url' do
    context 'with "cnn.com"' do
      specify { HitCounter.normalize_url('cnn.com').should == 'http://cnn.com' }
    end

    context 'with "http://www.nytimes.com"' do
      specify { HitCounter.normalize_url('http://www.nytimes.com').should == 'http://www.nytimes.com' }
    end
  end
end