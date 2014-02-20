class Document < ActiveRecord::Base
	has_attached_file :attachment#, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
	validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/

	has_one :status
	has_one :user


	attr_accessor :remove_attachment

	before_save :perform_attachment_removal
	def perform_attachment_removal
		if remove_attachment == '1' && !attachment.dirty?
			self.attachment = nil
		end
	end
end
