# Copyright the HitCounter contributors.
# SPDX-License-Identifier: MIT
# frozen_string_literal: true

require "#{File.dirname(__FILE__)}/../spec_helper"

JAVASCRIPT_HACK = %q(eval("console.log('All your base belong to us!')"))
# rubocop:disable Metrics/BlockLength
describe HitCounter do
  subject(:hit_counter) { described_class.get 'www.google.com' }

  describe '.get' do
    context 'with existing URL' do
      let!(:hit_counter2) { described_class.get hit_counter.url, 10 }

      # rubocop:disable RSpec/NestedGroups
      describe '.count' do
        it { expect(described_class.count).to eq 1 }
      end

      context 'with starting count 10' do
        describe '#hits' do
          it { expect(hit_counter2.hits).to eq 10 }
        end
      end
    end

    context 'with new URL' do
      before { described_class.get 'www.cnn.com' }

      describe '.count' do
        it { expect(described_class.count).to eq 2 }
      end

      context 'with blank starting count' do
        describe '#hits' do
          it do
            expect(described_class.get('www.nytimes.com', nil).hits).to eq 0
          end
        end
      end

      context 'with starting count 10' do
        describe '#hits' do
          it { expect(described_class.get('online.wsj.com', 10).hits).to eq 10 }
        end
      end
    end

    context 'with JavaScript' do
      subject(:hit_counter) { described_class.get(JAVASCRIPT_HACK) }

      before { described_class.delete_all }

      it do
        hit_counter.save
        expect(hit_counter).to be_invalid
      end
      # rubocop:enable RSpec/NestedGroups
    end
  end

  describe '.install' do
    before do
      allow(Object).to receive(:system)
      described_class.install
    end

    it('copies configuration files and images') do
      expect(Object).to have_received(:system).twice.with match(/config|public/)
    end
  end

  describe '#hits' do
    it { expect(hit_counter.hits).to eq 0 }

    context 'when incremented' do
      before { hit_counter.increment }

      it { expect(hit_counter.hits).to eq 1 }
    end
  end

  describe '#hits=' do
    context 'with JavaScript' do
      before { hit_counter.hits = JAVASCRIPT_HACK }

      it { expect(hit_counter.hits).to eq 0 }
    end
  end

  describe '#image' do
    context 'with a valid :style_number' do
      it { expect(hit_counter.image('1').filename).to eq "./public/images/digits/odometer/#{hit_counter.hits}.png" }
    end

    context 'with JavaScript' do
      it {
        expect(hit_counter.image(JAVASCRIPT_HACK).filename)
          .to eq "./public/images/digits/odometer/#{hit_counter.hits}.png"
      }
    end
  end

  describe '#url=' do
    context 'with JavaScript' do
      before do
        hit_counter.url = JAVASCRIPT_HACK
        hit_counter.save
      end

      it { expect(hit_counter).to be_invalid }
    end
  end

  describe '.normalize_style_number' do
    context 'with nil' do
      it { expect(described_class.send(:normalize_style_number, nil)).to be_zero }
    end

    context 'with empty string' do
      it { expect(described_class.send(:normalize_style_number, '')).to be_zero }
    end

    context 'with JavaScript' do
      it { expect(described_class.send(:normalize_style_number, JAVASCRIPT_HACK)).to be_zero }
    end

    context 'with number in range' do
      {
        '1' => 0,
        '3' => 2
      }.each do |input, output|
        # rubocop:disable RSpec/NestedGroups
        context "with '#{input}'" do
          it do
            expect(described_class.send(:normalize_style_number, input)).to eq output
          end
        end
        # rubocop:enable RSpec/NestedGroups
      end
    end

    context 'with number outside range' do
      {
        '-31' => 2,
        '-1' => 2,
        '4' => 0,
        '34' => 0
      }.each do |input, output|
        # rubocop:disable RSpec/NestedGroups
        context "with '#{input}'" do
          it do
            expect(described_class.send(:normalize_style_number, input)).to eq output
          end
        end
        # rubocop:enable RSpec/NestedGroups
      end
    end
  end

  describe '.normalize_url' do
    {
      'cnn.com' => 'http://cnn.com',
      'http://www.nytimes.com' => 'http://www.nytimes.com'
    }.each do |input, output|
      context "with '#{input}'" do
        it { expect(described_class.send(:normalize_url, input)).to eq output }
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
