# Simple environment-checking helpers to include in App
module Environment
  def development?
    if !ENV['DOCUMENT_APP_ENV']
      true
    elsif ENV['DOCUMENT_APP_ENV'] != 'production'
      true
    end
  end

  def production?
    ENV['DOCUMENT_APP_ENV'] == 'production'
  end
end