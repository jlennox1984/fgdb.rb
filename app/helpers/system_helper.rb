module SystemHelper
  class SystemParser
    attr_reader :processors, :l2_cache, :bios, :usb_supports, :drive_supports
    attr_reader :total_memory, :memories, :harddrives, :opticals, :pcis
    attr_reader :system_model, :system_serial_number, :system_vendor, :mobo_model, :mobo_serial_number, :mobo_vendor, :macaddr
    attr_reader :model, :vendor, :serial_number

    include XmlHelper

    def SystemParser.parse(in_string)
      sp = nil
      parser = Parsers.select{|x| in_string.match(/#{x.match_string}/)}.first or return false
      begin
        sp = parser.new(in_string)
      rescue SystemParserException
        return false
      end
      return sp
    end

    def initialize(in_string)
      @string = in_string

      @parser = load_xml(@string) or raise SystemParserException

      @processors = []
      @drive_supports = []
      @l2_cache = []
      @harddrives = []
      @memories = []
      @opticals = []
      @pcis = []

      do_work

      @parser = nil
      @string = nil

      if model_is_usable(@system_model)
        @model = @system_model
      elsif model_is_usable(@mobo_model)
        @model = @mobo_model
      else
        @model = "(no model)"
      end

      if vendor_is_usable(@system_vendor)
        @vendor = @system_vendor
      elsif vendor_is_usable(@mobo_vendor)
        @vendor = @mobo_vendor
      else
        @vendor = "(no vendor)"
      end

      if serial_is_usable(@system_serial_number)
        @serial_number = @system_serial_number
      elsif serial_is_usable(@mobo_serial_number)
        @serial_number = @mobo_serial_number
      elsif mac_is_usable(@macaddr)
        @serial_number = @macaddr
      else
        @serial_number = "(no serial number)"
      end
    end

    def find_system_id
      if @serial_number != "(no serial number)" && (found_system = System.find(:first, :conditions => {:serial_number => @serial_number, :vendor => @vendor, :model => @model}, :order => :id))
        return found_system.id
      else
        return nil
      end
    end

    private

    def is_usable(value, list_of_generics = [], check_size = false)
      return (value != nil && value != "" && !list_of_generics.include?(value) && (check_size == false || value.strip.length > 5))
    end

    def mac_is_usable(value)
      return is_usable(value)
    end

    def serial_is_usable(value)
      list_of_generics = Generic.find(:all).collect(&:value)
      return is_usable(value, list_of_generics, true)
    end

    def vendor_is_usable(value)
      list_of_generics = Generic.find(:all, :conditions => ['only_serial = ?', false]).collect(&:value)
      return is_usable(value, list_of_generics)
    end

    def model_is_usable(value)
      list_of_generics = Generic.find(:all, :conditions => ['only_serial = ?', false]).collect(&:value)
      return is_usable(value, list_of_generics)
    end
  end

  class SystemParserException < Exception
  end

  class LshwSystemParser < SystemParser
    include XmlHelper

    def self.match_string
      "generated by lshw"
    end

    def do_work
      # system data

      @parser.xml_foreach("//*[@class='system']") {
        @system_model ||= @parser._xml_value_of("/node/product")
        @system_serial_number ||= @parser._xml_value_of("/node/serial")
        @system_vendor ||= @parser._xml_value_of("/node/vendor")
        @mobo_model ||= @parser._xml_value_of("//*[contains(@id, 'core')]/product")
        @mobo_serial_number ||= @parser._xml_value_of("//*[contains(@id, 'core')]/serial")
        @mobo_vendor ||= @parser._xml_value_of("//*[contains(@id, 'core')]/vendor")
        @macaddr ||= @parser._xml_value_of("//*[contains(@id, 'network') or contains(description, 'Ethernet')]/serial")
      }

      # computer section

      @parser.xml_foreach("//*[@class='processor']") do
        if @parser.xml_if("product")
          h = OpenStruct.new
          h.processor = @parser.xml_value_of("product")
          h.speed = (@parser.xml_if("capacity") && false ? @parser.xml_value_of("capacity") : @parser.xml_value_of("size")).to_hertz if @parser.xml_if("capacity") || @parser.xml_if("size")

          h.supports = []
          find_these = ["lm", "svm", "vmx", "x86-64"]
          @parser.xml_foreach("capabilities/capability") do
            if find_these.include?(@parser.xml_value_of("@id"))
              h.supports << @parser.xml_value_of(".")
            end
          end
          @processors << h
        end
      end

      @bios = @parser.xml_value_of("//*[contains(@id, 'firmware')]/version")

      @parser.find_the_biggest("//node[contains(@id, 'usbhost')]/capabilities/capability", "USB ") do |value|
        @usb_supports = value
      end

      a = []; @parser.xml_foreach("//*[contains(@id, 'storage') or contains(@id, 'ide') or contains(@id, 'scsi')]") do a << @parser.xml_value_of(".//product") + @parser.xml_value_of(".//description") end
      a.collect{|x| if x.match(/(scsi|sata|ide)/i); $1.upcase; else nil; end}.delete_if{|x| x.nil?}.uniq.each do |x|
        @drive_supports << x
      end

      @parser.xml_foreach("//*[@class='memory']") do
        if @parser.xml_value_of("description") == "L2 cache"
          @l2_cache << @parser.xml_value_of("size").to_bytes # the description is always L2 cache
        end
      end

      # hard drives
      @parser.xml_foreach("//*[contains(@id, 'disk')]") do
        h = OpenStruct.new
        h.name = @parser.xml_value_of("logicalname")
        h.my_type = (@parser.do_with_parent do @parser.xml_value_of(".//product") + @parser.xml_value_of(".//description") end).match(/(scsi|sata|ide)/i) ? $1.upcase : "Unknown"
        h.vendor = @parser.xml_value_of("vendor")
        h.model = @parser.xml_value_of("product")
        h.size = @parser.xml_if("size") ? @parser.xml_value_of("size").to_bytes(0, false, false) : @parser.xml_if("capacity") ? @parser.xml_value_of("capacity").to_bytes(0, false, false) : nil
        h.volumes = []
        @parser.xml_foreach(".//*[contains(@id, 'volume')]") do
          v = OpenStruct.new
          v.name = @parser.xml_value_of("logicalname")
          v.description = @parser.xml_value_of("description")
          v.size = @parser.xml_value_of("capacity").to_bytes(0, false, false)
          h.volumes << v
        end
        @harddrives << h
      end

      # memory
      @parser.xml_foreach("//*[contains(@id, 'memory')]") do
        if @parser.xml_if("size")
          @total_memory = @parser.xml_value_of("size").to_bytes(1)
        end
      end


      @parser.xml_foreach(".//*[contains(@id, 'bank')]") do
        m = OpenStruct.new
        m.bank = @parser.xml_value_of("@id").sub(/^bank:/, "")
        m.description = @parser.xml_value_of("description")
        m.size = @parser.xml_value_of("size").to_bytes if @parser.xml_if("size")
        @memories << m
      end

      # optical
      @parser.xml_foreach("//node[contains(@id, 'cdrom')]") do
        h = OpenStruct.new
        h.name = @parser.xml_value_of("logicalname")
        h.description = @parser.xml_value_of("description")
        a = []
        @parser.xml_foreach("capabilities/capability") do
          a << [@parser.xml_value_of("."), @parser.xml_value_of("@id")]
        end
        a = a.select{|a| a[1].match(/(cd|dvd)/)}
        h.capabilities = a.map{|x| x[0]}.to_sentence
        h.my_type = (@parser.do_with_parent do @parser.xml_value_of("product") + @parser.xml_value_of("description") end).match(/(scsi|sata|ide)/i) ? $1.upcase : "Unknown"
        h.model = @parser.xml_value_of("product")
        @opticals << h
      end

      # pci
      @seen = []
      @seen_ser = []

      @parser.xml_foreach("//*[contains(@id, 'pci') or contains(@id, 'pcmcia')]") do
        h = OpenStruct.new
        h.title = @parser._xml_value_of("product")
        h.devices = []
        @parser.xml_foreach("./node[contains(@handle, 'PCI:') or contains(@handle, 'PCMCIA:')]") do
          if !['bus', 'bridge', 'storage', 'system', 'memory'].include?(@parser.xml_value_of("@class"))
            t = pci_stuff
            h.devices << t if t
          end
        end
        @pcis << h
      end

      h = OpenStruct.new
      h.title = "Unknown"
      h.devices = []
      @parser.xml_foreach("//node[not(@class='bus')
                      and not(@class='bridge')
                      and not(@class='storage')
                      and not(@class='system')
                      and not(@class='processor')
                      and not(@class='volume')
                      and not(@class='disk')
                      and not(@class='memory')]") do
        t = pci_stuff
        h.devices << t if t
      end
      @pcis << h

      @seen = nil
      @seen_ser = nil
    end

    private

    def pci_stuff
      my_id = @parser.my_node
      my_ser = @parser.xml_value_of("serial")
      my_ser = nil if my_ser == "Unknown"
      if @seen.include?(my_id) || (my_ser && @seen_ser.include?(my_ser))
        return false
      else
        @seen << my_id
        @seen_ser << my_ser if my_ser
      end

      d = OpenStruct.new
      d.my_type = @parser.xml_value_of("@class") if @parser.xml_if("@class")
      if @parser.xml_if("description")
        d.description = @parser.xml_value_of("description")
        handle = @parser.xml_value_of("@handle").sub(" ", "")
        if handle.length > 0
          d.description += " (#{ handle })"
        end
      end
      d.vendor = @parser.xml_value_of("vendor") if @parser.xml_if("vendor")
      d.product = @parser.xml_value_of("product") if @parser.xml_if("product")
      # if false && @parser.xml_value_of("@class")=="display" && @parser.xml_if("size") %><%# not tested after nokogiri %>
      # Video Ram: <%= @parser.xml_value_of("size").to_bytes %>
      # if false && @parser.xml_value_of("@class")=="network" && @parser.xml_if("configuration/setting[@id='wireless']")
      # Wireless Capabilities: <%= @parser.xml_value_of("configuration/setting[@id='wireless']/@value") %>
      # if false && @parser.xml_value_of("@class")=="network" && @parser.xml_if("logicalname") %><%# not tested after nokogiri %>
      # Ethernet Interface:  <%= @parser.xml_value_of("logicalname") %>
      if @parser.xml_value_of("@class")=="network" && @parser.xml_if("capabilities")
        @parser.find_the_biggest(".//capability/@id") do |value|
          d.speed = value.to_i.to_s.to_bitspersecond
        end
      end

      return d
    end
  end

  # TODO: replace open structs with actual struct classes shared by the parsers (so under the module)...this way we can ensure things are done without typos in code.

  class PlistSystemParser < SystemParser
    def self.match_string
      "DOCTYPE plist"
    end

    def do_work
      @result = Nokogiri::PList::Parser.parse(@parser.my_node)
      begin
        @macaddr = @result.map{|x| x["_items"]}.flatten.select{|x| x["_name"] == "Built-in Ethernet"}.first["Ethernet"]["MAC Address"]
      rescue
      end
      begin
      rescue
        @memories = @result.map{|x| x["_items"]}.flatten.select{|x| x["dimm_status"]}.map{|x|
          d = OpenStruct.new
          d.bank = x["_name"]
          d.description = [x["dimm_type"], x["dimm_speed"]].join(" ")
          d.size = x["dimm_size"]
          d
        }
      end
      @result = nil
    end
  end

  SystemParser::Parsers = [PlistSystemParser, LshwSystemParser]
end
