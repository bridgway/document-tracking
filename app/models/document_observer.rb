class DocumentObserver < ActiveRecord::Observer
  def after_save(document)
    if document.status_changed?
      if document.status = :signed
        activity = {
          created_at: DateTime.now,
          document_id: document.id,
          message: "#{document.signee.name} signed #{document.file.source.file.filename}"
        }

        document.user.add_document_activity activity
      end
    end
  end
end