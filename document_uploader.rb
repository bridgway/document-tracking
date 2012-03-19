require 'carrierwave'

class DocumentUploader < CarrierWave::Uploader::Base
  storage :file
end