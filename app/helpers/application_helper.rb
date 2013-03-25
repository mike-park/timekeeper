# -*- coding: utf-8 -*-

module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def my_label(string)
    content_tag(:span, string, class: :label)
  end

  def number_to_euro(amount)
    number_to_currency(amount, :unit=>'€') #.gsub(' ', '&nbsp;')
  end

  def td_money(amount)
    content_tag(:td, number_to_euro(amount), class: 'money')
  end

  def service_type_name(key)
    current_praxis.service_types[key.to_sym]
  end

  def link_to_client(client)
    link_to(client.full_name, client)
  end

  def client_name(client, options = {})
    length = options[:length] || (printing? ? 30 : 16)
    if client
      name = client.full_name.slice(0, length)
      name += ".." if client.full_name.length > length
    else
      name = ''
    end
    # HACK ALERT this is not safe. we should be doing html_safe to the &nbsp;
    name.gsub(/\s/,"&nbsp;").html_safe
  end

  def datepicker_field(form, field_name, default_date = Date.current)
    value = form.object.send(field_name) || default_date
    value = value.to_s(:long_de) if value
    form.input field_name, as: :string,  input_html: {class: 'date-picker span2', value: value }
  end

  def service_type_field(form, field_name)
    form.input field_name, collection: current_praxis.service_types.map{|k,v| [v, k.to_s]}
  end

  def sidebar_link(text, url, options = {})
    content_tag(:p, link_to(text, url, options.merge(class: 'btn span3')))
  end

  def add_action(text, url, icon = "", options = {})
    icon = "<i class='icon-#{icon}'></i>".html_safe if icon.present?
    content_for(:actions) do
      content_tag(:li, link_to(icon + text, url, options))
    end
  end

  def print_button(text, options = {})
    url_options = params.merge(options.merge(print: true, format: 'pdf'))
    content_tag(:span, class: 'pull-right print-button') do
      link_to(text, url_for(url_options), class: 'btn btn-large btn-primary', target: 'printer')
    end
  end

  def csv_button(text, options = {})
    url_options = params.merge(options.merge(format: 'csv'))
    content_tag(:span, class: 'pull-right print-button') do
      link_to(text, url_for(url_options), class: 'btn btn-large btn-primary')
    end
  end

  def dropdown_menu(name, items, label_method = :label)
    content_tag(:li, class: 'dropdown', data: { dropdown: 'dropdown'}) do
      content = link_to(name, '#', class: 'dropdown-toggle')
      content << content_tag(:ul, class: 'dropdown-menu') do
        items.map do |item|
          content_tag(:li, link_to(item.send(label_method), "##{item.class.model_name.parameterize}_#{item.id}"))
        end.join.html_safe
      end
      content
    end
  end

  def link_to_google_map(address)
    link_to(address, "http://maps.google.com/?q=#{address}", target: 'map')
  end

  def edit_link(url)
    link_to(url, title: 'Edit item') {content_tag(:i, '', class: 'icon-edit')}
  end

  def show_link(url)
    link_to(url, title: 'More details') { content_tag(:i, '', class: 'icon-zoom-in') }
  end

  def new_link(name, url)
    link_to(url, class: 'btn btn-large btn-new', title: name) do
      content_tag(:i, '', class: 'icon-plus') + " #{name}"
    end
  end

  def destroy_link(url)
    link_to(url, data: {confirm: 'Are you sure you want to delete this?'}, method: :delete, title: 'Destroy item') do
      content_tag(:i, '', class: 'icon-trash')
    end
  end

  def cancel_link(url)
    link_to('Cancel', url, title: 'Cancel change', class: 'btn btn-small')
  end

  def tick_if(value)
    content_tag(:i, '', class: 'icon-ok') if value
  end

  def color_box(color)
    content_tag(:div, ' ', style: "height: 1em; width: 100px; background-color: #{color};")
  end
end
