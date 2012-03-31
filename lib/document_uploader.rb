require 'carrierwave'
require 'carrierwave-docsplit'

class DocumentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  extend CarrierWave::DocsplitIntegration
  include ::CarrierWave::Backgrounder::DelayStorage

  def store_dir
    File.expand_path(File.join($ROOT, 'public/uploads'))
  end

  def self.store_dir
    File.expand_path(File.join($ROOT, 'public/uploads'))
  end

  # THIS HURTS SO MUCH TO PUT IT HERE.
  # But, it gets a circular dependency going if you put it in it's rightful place in DocumentFile

  IMAGE_SIZES = {}
  IMAGE_SIZES['large']      = '1000x'
  IMAGE_SIZES['normal']     = '700x'
  IMAGE_SIZES['small']      = '180x'
  IMAGE_SIZES['thumbnail']  = '60x75!'

  storage :file

  extract :images => {:to => :thumbs, :sizes => IMAGE_SIZES }, :text => { :to => :text }

  version :large do
    process :convert_and_scale => '300x400'

    def full_filename(for_file)
     super(for_file).chomp(File.extname(super(for_file))) + '.png'
    end
  end

  version :thumb, :from_version => :large do
    process :convert_and_scale => '200x200'

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
end