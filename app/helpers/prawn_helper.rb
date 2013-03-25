module PrawnHelper
  require 'prawn/measurement_extensions'

  def content_for_prawn(options = {}, &block)
    options.reverse_merge!(:page_size => 'A4',
                           :page_layout => :portrait,
                           :margin => [1.cm, 1.cm])

    pdf = Prawn::Document.new(options)
    default_layout(pdf, options, &block)
    pdf.render.html_safe
  end

  protected

  def default_layout(pdf, options, &block)
    yield pdf
  end
end
