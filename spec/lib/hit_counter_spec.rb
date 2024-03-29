# Copyright the HitCounter contributors.
# SPDX-License-Identifier: MIT
# frozen_string_literal: true

require "#{File.dirname(__FILE__)}/../spec_helper"

JAVASCRIPT_HACK = %q(eval("console.log('All your base belong to us!')"))
# rubocop:disable Metrics/BlockLength
describe HitCounter do
  before(:all) { described_class.delete_all }

  subject { described_class.get 'www.google.com' }

  describe '.get' do
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
    context 'with JavaScript' do
      before { described_class.delete_all }

      subject { described_class.get(JAVASCRIPT_HACK) }

      it do
        subject.save
        expect(subject).to be_invalid
      end
    end
  end
  describe '.install' do
    before do
      expect_any_instance_of(Object).to receive(:system).twice.with match(/config|public/)
    end

    it('copies configuration files and images') { described_class.install }
  end
  describe '#hits' do
    it { expect(subject.hits).to eq 0 }

    context 'when incremented' do
      before { subject.increment }

      it { expect(subject.hits).to eq 1 }
    end
  end
  describe '#hits=' do
    context 'with JavaScript' do
      before { subject.hits = JAVASCRIPT_HACK }

      it { expect(subject.hits).to eq 0 }
    end
  end
  describe '#image' do
    context 'with a valid :style_number' do
      it { expect(subject.image('1').filename).to eq "./public/images/digits/odometer/#{subject.hits}.png" }
    end
    context 'with JavaScript' do
      it {
        expect(subject.image(JAVASCRIPT_HACK).filename).to eq "./public/images/digits/odometer/#{subject.hits}.png"
      }
    end
  end
  describe '#url=' do
    context 'with JavaScript' do
      before do
        subject.url = JAVASCRIPT_HACK
        subject.save
      end

      it { expect(subject).to be_invalid }
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
