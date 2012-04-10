class ImportController < ApplicationController
  def freshbooks
    # Enact the import
    if request.method == "POST"
      current_user.import :from => :freshbooks, :info => { }
    else
      # otherwise render the form.
      render :freshbooks
    end
  end
end
