class AddAttachmentDocumentToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :document
    end
  end

  def self.down
    drop_attached_file :users, :document
  end
end
