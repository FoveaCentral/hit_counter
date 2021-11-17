# Copyright the HitCounter contributors.
# SPDX-License-Identifier: MIT
# frozen_string_literal: true

require "#{File.dirname(__FILE__)}/../../spec_helper"

describe :install do
  before do
    expect_any_instance_of(Object).to receive(:system).twice.with match(/config|public/)
  end

  it 'copies configuration files and images' do
    Rake::Task['hit_counter:install'].invoke
  end
end
