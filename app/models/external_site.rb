class ExternalSite < ActiveRecord::Base
  attr_accessible :name

  has_many :site_authorizations
  has_many :certificates, through: :site_authorizations
end
