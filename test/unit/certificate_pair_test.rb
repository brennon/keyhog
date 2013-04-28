require 'test_helper'

class CertificatePairTest < ActiveSupport::TestCase
  test 'should exist' do
    assert_nothing_raised do
      CertificatePair.new
    end
  end
end
