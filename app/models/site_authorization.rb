class SiteAuthorization < ActiveRecord::Base
  attr_accessible :certificate_id, :external_site_id

  belongs_to :external_site
  belongs_to :certificate
end
