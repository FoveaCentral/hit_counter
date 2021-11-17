# Copyright the HitCounter contributors.
# SPDX-License-Identifier: MIT
# frozen_string_literal: true

require "#{File.dirname(__FILE__)}/../spec_helper"
# rubocop:disable Metrics/BlockLength
describe HitCounter do
  before(:all) { described_class.delete_all }

  subject { described_class.get 'www.google.com' }

  describe '#get' do
    context 'with existing URL' do
      let!(:hit_counter2) { described_class.get subject.url, 10 }

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
  end
  describe '#hits' do
    it { expect(subject.hits).to eq 0 }

    context 'when incremented' do
      before { subject.increment }

      it { expect(subject.hits).to eq 1 }
    end
  end
  describe '#image' do
    it { expect(subject.image('1')).to be_a Magick::Image }
  end
  describe '#normalize_style_number' do
    context 'with nil' do
      it { expect(described_class.send(:normalize_style_number, nil)).to be_zero }
    end
    context 'with empty string' do
      it { expect(described_class.send(:normalize_style_number, '')).to be_zero }
    end
    context 'with number in range' do
      {
        '1' => 0,
        '3' => 2
      }.each do |input, output|
        context "with '#{input}'" do
          it do
            expect(described_class.send(:normalize_style_number, input)).to eq output
          end
        end
      end
    end
    context 'with number outside range' do
      {
        '-31' => 2,
        '-1' => 2,
        '4' => 0,
        '34' => 0
      }.each do |input, output|
        context "with '#{input}'" do
          it do
            expect(described_class.send(:normalize_style_number, input)).to eq output
          end
        end
      end
    end
  end
  describe '#normalize_url' do
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
