require 'minitest/unit'
require 'minitest/autorun'

require 'document_importer'

class TestDocumentImporter < MiniTest::Unit::TestCase

  def test_extracting_image_from_pdf_should_succed
    DocumentImporter.extract_images "public/w9.pdf"
  end

    def teardown
    FileUtils.rm_rf Dir['tmp/images/*']
  end
end