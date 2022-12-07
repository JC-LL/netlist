module Netlist

  class Port
    attr_accessor :name,:fanin,:fanout
    attr_accessor :direction
    attr_accessor :circuit
    def initialize name,direction
      @name=name
      @circuit=circuit
      @direction=direction
      @fanin,@fanout=[],[]
    end

    def to pdest # e : Port
      @fanout << pdest
      pdest.fanin << self
    end
  end

  class Circuit
    attr_accessor :name,:ports,:components
    def initialize name
      @name=name
      @ports={:in=>[],:out=>[]}
      @components=[]
    end

    def <<(e)
      case e
      when Port
        @ports[e.direction] << e
        e.circuit=self
      when Circuit
        @components << e
      end
    end

    alias :ajoute :<<

    def get_port_named str
      @ports.values.flatten.find{|port| port.name==str}
    end

    def get_component_named str
      @components.find{|comp| comp.name==str}
    end

    def inputs
      @ports[:in]
    end

    def outputs
      @ports[:out]
    end

  end
end
