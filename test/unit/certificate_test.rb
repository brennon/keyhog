require 'test_helper'

class CertificateTest < ActiveSupport::TestCase
  setup do
    @certificate = FactoryGirl.create(:certificate)
  end
  
  should validate_presence_of :contents
  should validate_presence_of :nickname
  should validate_presence_of :user_id

  should validate_uniqueness_of :nickname

  should allow_value('ssh-rsa ahfkewql&(rqoFHo homeCert').for(:contents)
  should_not allow_value('ssh-asa ahfkewql&(rqoFHo homeCert').for(:contents)
  should_not allow_value('ahfkewql&(rqoFHo').for(:contents)

  should belong_to :user

  test "certificate should respond to :calculate_fingerprint" do
    assert_respond_to @certificate, :calculate_fingerprint
  end

  test ":calculate_fingerprint returns the correct hash of a certificate" do
    certificate = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCu+JHZuPV0frXX4IFBQE7fFzg2QKRVjMJWV4qnrTDi/dd5S1DPxmRs+b3MdPpiFYvJrW3ZgI1KCrd0N5haq4BMhDgi/O7gL5slUnt6pol+tp6eoC3bd36zmLnAM7yT03vDCCYOrph/sIMCg666KvWdP2VzF50ONoca8K4oz+SRnNZFqzPgfYTxkK0Ft77eMFTwl0gxB6b8AmL611ycKBKhXM3pBMa5Avq4LmGozgnFt/2tHwCltdYK/L7PvhAdmb+0mBSrhU8v2V7Zt50gUbpkAXaGh6rOVRBwKV7tMVp4lwCdr5PjM++SPYGKjv0nZt4tXq14S5mN/Du09Hgzb5SP certificatename"
    assert_equal "3e3dfbde5892e14968ab039c3bbf0175", @certificate.calculate_fingerprint(certificate)
  end

  test "saving certificate stores fingerprint" do
    certificate = FactoryGirl.create(:certificate, fingerprint: nil)
    certificate.reload
    assert_not_nil certificate.fingerprint
  end

  test ":prettify_fingerprint" do
    assert_respond_to @certificate, :prettify_fingerprint
  end

  test ":prettify_fingerprint prettifies a fingerprint" do
    assert_equal "ab:cd:ef:gh", @certificate.prettify_fingerprint("abcdefgh")
  end
end
