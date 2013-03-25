# encoding: utf-8

class TorgDiff
  include ActionView::Helpers::TranslationHelper

  def initialize(current, previous)
    @current = current
    @previous = previous
  end

  def title
    s = changes.any? ? 'Wechselt' : 'Keine Änderungen'
    s += " zwischen #{localize @previous.created_at} und #{localize @current.created_at}"
    s
  end

  def changes
    @changes ||= diff
  end

  private

  def diff
    changes = (@current.data - @previous.data).map {|row| Line.new(row, :insert)}
    changes += (@previous.data - @current.data).map {|row| Line.new(row, :delete)}
    changes.sort
  end

  class Line
    attr_reader :row

    def initialize(row, action)
      @row = row
      @action = action
    end

    def to_s
      case @action
        when :insert then as_insert
        when :delete then as_delete
      end
    end

    def <=>(other)
      # sort by lastname, firstname, occurred_on
      compare = row[0] <=> other.row[0]
      if compare == 0
        compare = row[1] <=> other.row[1]
        if compare == 0
          compare = to_date(row[2]) <=> to_date(other.row[2])
        end
      end
      compare
    end

    private

    def to_date(string)
      Date.strptime(string, '%d.%m.%y')
    end

    def row_to_s
      row.map {|item| "<td>#{item}</td>"}.join("")
    end

    def as_insert
      %Q{<tr class="differ-ins"><td><i class="icon-plus"></i></td>#{row_to_s}</tr>}.html_safe
    end

    def as_delete
      %Q{<tr class="differ-del"><td><i class="icon-minus"></i></td>#{row_to_s}</tr>}.html_safe
    end
  end
end
