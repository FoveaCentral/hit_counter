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
    subject { @hit_counter.image }

    it { should be_a Magick::Image }
    pending 'should reflect hits'
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