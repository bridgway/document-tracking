require 'json'

class Importer

  @queue = :document_importing

  def self.perform(klass, id, column)
    puts "aoeuaoeue"
    file = DocumentFile.find id
    file.source.process!
    file.source.store!
  end
end