require "../lib/netlist.rb"

include Netlist

class C < Circuit
  def initialize instance_name
    super(instance_name)
    ["aa","bb"].each{|name|  @ports[:in] << Port.new(name,:in)}
    ["f1","f2"].each{|name| @ports[:out] << Port.new(name,:out)}
  end
end


class A < Circuit
  def initialize instance_name
    super(instance_name)
    @ports[:in] << Port.new("e",:in)
    @ports[:out] << Port.new("f",:out)
  end
end

class B < Circuit
  def initialize instance_name
    super(instance_name)
    @ports[:in] << Port.new("e1",:in)
    @ports[:in] << Port.new("e2",:in)
    @ports[:out] << Port.new("f",:out)
  end
end

c=      C.new("c")
c << a1=A.new("a1")
c << a2=A.new("a2")
c <<  b=B.new("b")

c_a=c.get_port_named("aa")
c_b=c.get_port_named("bb")
c_f1=c.get_port_named("f1")
c_f2=c.get_port_named("f2")

a1_e=c.get_component_named("a1").get_port_named("e")
a1_f=c.get_component_named("a1").get_port_named("f")
a2_e=c.get_component_named("a2").get_port_named("e")
a2_f=c.get_component_named("a2").get_port_named("f")

b_e1=c.get_component_named("b").get_port_named("e1")
b_e2=c.get_component_named("b").get_port_named("e2")
b_f=c.get_component_named("b").get_port_named("f")

c_a.to a1_e
c_a.to b_e1
c_b.to b_e2
a1_f.to a2_e
a2_f.to c_f1
b_f.to c_f2

Viewer.new.view c
