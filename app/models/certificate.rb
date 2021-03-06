require 'base64'
require 'digest/md5'

class Certificate < ActiveRecord::Base
  attr_accessible :contents, :fingerprint, :nickname, :user_id, :active

  belongs_to :user
  has_many :site_authorizations
  has_many :external_sites, through: :site_authorizations

  before_save :store_fingerprint

  validates_presence_of :contents
  validates_presence_of :nickname
  validates_presence_of :user_id

  validates_format_of :contents, with: /\Assh-(rsa1|rsa|dsa|dss) \S* \S*/

  validates_uniqueness_of :nickname

  def store_fingerprint
    self.fingerprint = calculate_fingerprint self.contents
  end

  def calculate_fingerprint(certificate_body)
    return nil if !certificate_body

    bare_key = certificate_body.split(' ')[1]
    key_64 = Base64.decode64(bare_key)
    Digest::MD5.hexdigest(key_64)
  end

  def prettify_fingerprint(fingerprint)
    result = ""
    for i in 0..(fingerprint.length - 1) do
      result += ":" if (i % 2 == 0) && (i > 0)
      result += fingerprint[i]
    end
    result
  end
end
