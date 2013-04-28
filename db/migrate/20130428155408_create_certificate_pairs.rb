class CreateCertificatePairs < ActiveRecord::Migration
  def change
    create_table :certificate_pairs do |t|

      t.timestamps
    end
  end
end
