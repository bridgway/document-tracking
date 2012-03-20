require 'carrierwave'

class DocumentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  version :thumb do
    process :convert_and_scale

    def full_filename(for_file)
     super(for_file).chomp(File.extname(super(for_file))) + '.png'
    end
  end

  def convert_and_scale
    manipulate! do |image|
      image.format 'png'
      image.resize '200x200'
      image
    end
  end

  def set_content_type(*args)
    self.file.instance_variable_set(:@content_type, "image/png")
  end
end