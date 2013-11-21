# encoding: utf-8
module BillsHelper

  def bill_to_pdf(bill)
    content_for_prawn(page_layout: :portrait,
                      margin: [2.cm, 2.cm]) do |pdf|
      cover_page(pdf, bill)
      clients_page(pdf, bill)
    end
  end

  def cover_page(pdf, bill)
    pdf.font "Times-Roman"
    pdf.font_size(11)
    pdf.move_down(3.cm)
    pdf.text <<EOF
  An die
  Frühförderung Gütersloh – IFF Zeitzen
  Fröbelstr.32

  33330 Gütersloh








EOF
    table = [
        ['Re-Nr: IFF-Zeitzen', bill.number],
        [' ',' '],
        ['',"Gütersloh, den #{bill.billed_on.to_s(:de)}"]
    ]
    pdf.table(table,
              :width => pdf.bounds.width,
              cell_style: { borders: [] },
              :column_widths => [10.cm]) do
      cells.padding = 0
    end

    pdf.text <<EOF


  Sehr geehrte Damen und Herren,

  im Rahmen der Interdisziplinären Frühförderung Gütersloh – IFF Zeitzen stelle
  ich Ihnen folgende Rechnung:


EOF
    data = cover_table(bill)
    last_row = data.length - 1
    pdf.table(data,
              cell_style: { borders: [:top], border_widths: 0.1 }) do
      cells.padding = 3
      row(0).borders = []
      row(0).font_style = :bold
      row(last_row).font_style = :bold
      columns(1..3).align = :right
    end
    pdf.text <<EOF


Zahlen Sie den Rechnungsbetrag unter Angabe der Rechnungsnummer bitte auf
mein Konto bei der #{bill.therapist.bank}, Konto #{bill.therapist.konto_nr}, BLZ #{bill.therapist.blz}.
EOF
  end

  def cover_table(bill)
    table = []
    table << ['Behandlungsart', 'Zahl der Fördereinheiten', 'Preis je Einheit', 'Summe']
    bp = BillPresenter.new(bill)
    bp.services(all: true).each do |s|
      table << [s.name, s.qty, prawn_euro(s.price), prawn_euro(s.total)]
    end
    table << ['Gesamtbetrag', nil, nil, prawn_euro(bill.total)]
    table
  end

  def clients_page(pdf, bill)
    pdf.start_new_page(:size => "A4", :layout => :landscape)
    pdf.font "Times-Roman"
    pdf.font_size(11)
    pdf.text "Abrechnung Fördereinheiten #{bill.therapist.full_name} #{bill.billed_on.to_s(:de)}",
             size: 18, style: :bold
    pdf.text "\n"
    data = clients_table(bill)
    last_row = data.length - 1
    pdf.table(data,
              header: true,
              cell_style: { borders: [:top, :left, :right, :bottom], border_widths: 0.1 }) do
      cells.padding_left = 4
      cells.padding_right = 4
      cells.padding_top = 2
      cells.padding_bottom = 2
      cells.width = 2.5.cm
      cells.align = :center
      column(0).width = 5.cm
      row(0).borders = []
      row(0).font_style = :italic
      column(0).align = :left
      column(1).align = :center
      last_rows = (last_row-2)..last_row
      row(last_row-3).column(0).align = :right
      row(last_rows).align = :right
      row(last_row).font_style = :bold
    end
  end

  def clients_table(bill)
    bp = BillPresenter.new(bill)
    table = []
    table << (%w(Name Geburts-datum) + bp.service_names)
    bp.clients.each do |c|
      row = [c.full_name, c.dob]
      row += bp.service_abbrvs.map {|abbrv| c.services[abbrv].qty if c.services[abbrv]}
      table << row
    end
    table << (['Summe',''] + extract_services(bp, :qty){|i| i})
    table << (['Preis',''] + extract_services(bp, :price){|i| prawn_euro(i)})
    table << (['Teilsummen',''] + extract_services(bp, :total){|i| prawn_euro(i)})
    table << ['Gesamt', '', prawn_euro(bill.total)]
    table
  end

  def extract_services(bp, value, &block)
    bp.service_abbrvs.map do |abbrv|
      if bp.services[abbrv]
        yield bp.services[abbrv].send(value)
      end
    end
  end

  def prawn_euro(value)
    number_to_currency(value).to_s.gsub(/\s/, Prawn::Text::NBSP)
  end
end
