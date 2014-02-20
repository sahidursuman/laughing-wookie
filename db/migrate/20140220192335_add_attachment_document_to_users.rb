class AddAttachmentDocumentToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      add_attachment :document
    end
  end

  def self.down
    remove_attachment :users, :document
  end
end
