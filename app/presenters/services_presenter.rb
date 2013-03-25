# aggregates many services into the smallest number of services & clients

class ServicesPresenter
  def initialize(services)
    @src_services = services
  end

  def clients(options = {})
    @clients ||= aggregate_clients(@src_services, options)
  end

  def services(options = {})
    @services ||= aggregate_services(@src_services, options)
  end

  def service_names(options = {})
    services(options).map(&:name)
  end

  def service_abbrvs(options = {})
    services(options).map(&:abbrv)
  end

  private

  def aggregate_clients(services, options)
    clients = {}
    services.each do |s|
      client = s.client
      clients[client.fingerprint] ||= ClientPresenter.new(client, options)
      clients[client.fingerprint].add(s)
    end
    clients.sort.map {|arr| arr[1]}
  end

  def aggregate_services(services, options)
    stg = ServiceTypeGroup.new(options.merge(name: 'Total'))
    services.each do |s|
      stg.add(s)
    end
    stg
  end

  class Item
    attr_reader :name, :abbrv, :index

    def initialize(options = {})
      @name = options[:name] || options[:title]
      @abbrv = options[:abbrv]
      @occurred_on = []
      @billed_on = []
    end

    def add(item)
      @qty ||= 0
      @index ||= 0
      @total ||= BigDecimal("0.00")

      @total += item.price if item.price
      @index += 1
      @qty += 1

      @occurred_on << item.occurred_on
      @billed_on << item.billed_on
    end

    def occurred_on
      @occurred_on.compact.sort
    end

    def billed_on
      @billed_on.compact.sort
    end

    def qty
      @qty
    end

    def total
      @total
    end

    def price
      total / qty if total && qty && qty != 0
    end

    def to_s
      @qty.to_s
    end
  end


  class Group
    include Enumerable

    attr_reader :name, :abbrv

    def initialize(options = {})
      @name = options[:name]
      @abbrv = options[:abbrv]
      @sort_order = options[:sort_order]
      @items = {}
    end

    # group by :abbrv, and name it :name
    def add(service, options)
      i = find_or_create_item(options)
      i.add(service)
    end

    def each
      order = @sort_order || @items.keys
      order.each {|abbrv| yield(self[abbrv]) if self[abbrv]}
    end

    def [](abbrv)
      @items[abbrv.to_sym]
    end

    def qty
      items = item_values(:qty)
      items.sum if items.any?
    end

    def total
      items = item_values(:total)
      items.sum if items.any?
    end

    def occurred_on
      item_values(:occurred_on).flatten.compact.uniq.sort
    end

    def billed_on
      item_values(:billed_on).flatten.compact.uniq.sort
    end

    def price
      total / qty if total && qty && qty != 0
    end

    def to_s
      qty.to_s
    end

    private

    def item_values(method)
      @items.values.map{|v| v.send(method) }.compact
    end

    def find_or_create_item(options)
      @items[options[:abbrv]] ||= Item.new(options)
    end
  end

  class TherapistTypeGroup < Group
    def initialize(options = {})
      therapist_types = Therapist.all.map(&:category)
      super(options.merge(sort_order: therapist_types))
      therapist_types.each {|name| find_or_create_item(abbrv: name, name: name.to_s.upcase)}
    end

    def add(billed_service, options = {})
      tt = billed_service.therapist.category.to_sym
      attrs = options.merge(abbrv: tt, name: tt)
      super(billed_service, attrs)
    end
  end

  class ServiceTypeGroup < Group
    def initialize(options = {})
      service_types_keys = %w(IG ED EG EGF ET GT VD AD)
      super(options.merge(sort_order: service_types_keys))
      # if :all => true pre-create all service types
      if options[:all]
        EventCategory.all.map do |ec|
          find_or_create_item(abbrv: ec.abbrv.to_sym, name: ec.title)
        end
      end
    end

    def add(service, options = {})
      st = service.event_category.abbrv.to_sym
      attrs = options.merge(abbrv: st,
                            name: service.event_category.title)
      super(service, attrs)
    end

    private

    def find_or_create_item(options)
      @items[options[:abbrv]] ||= TherapistTypeGroup.new(options)
    end
  end

  class ClientPresenter
    attr_reader :dob, :client

    delegate :first_name, :last_name, :full_name, :to => :client

    def initialize(client, options)
      @counts = {}
      @client = client
      @dob = client.dob.to_s(:de)
      @options = options
    end

    def add(service)
      services.add(service)
    end

    def services
      @services ||= ServiceTypeGroup.new(@options)
    end
  end
end
