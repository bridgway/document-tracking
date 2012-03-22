require 'carrierwave'

class DocumentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  version :thumb do
    process :convert_and_scale => '200x200'

    def full_filename(for_file)
     super(for_file).chomp(File.extname(super(for_file))) + '.png'
    end
  end

  version :large do
    process :convert_and_scale => '300x400'

    def full_filename(for_file)
     super(for_file).chomp(File.extname(super(for_file))) + '.png'
    end
  end

  def convert_and_scale(size)
    manipulate! do |image|
      image.format 'png'
      image.resize size
      image
    end
  end

  def set_content_type(*args)
    self.file.instance_variable_set(:@content_type, "image/png")
  end

  def store_dir
    if App.production?
      # probably S3
    else
      # TODO: Use App.root
      "uploads/"
    end
  end
end