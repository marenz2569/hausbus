#!/usr/bin/env python3
from lxml import etree
from sys import argv
import sys

def eprint(*args, **kwargs):
	print(*args, file=sys.stderr, **kwargs)

def depth(node):
	d=0
	while node is not None:
		d+=1
		node=node.getparent()
	return d

def module_pwm(module, conf):
	if conf == "":
		conf = """#define PWM_TABLE \\
"""
	else:
		conf += """        ID(""" + module.attrib['id']  + """) \\
"""
		j=0
		for i in module:
			conf += """        ENTRY(""" + str(j) + """, """ + i.attrib['pin'][:1] + """, """ + i.attrib['pin'][1:] + """) \\
"""
			j+=1
	return [conf, ""]

def module_output(module, conf):
	if conf == "":
		conf = """#define OUTPUT_TABLE \\
"""
	else:
		conf += """        ID(""" + module.attrib['id']  + """) \\
"""
		j=0
		for i in module:
			conf += """        ENTRY(""" + str(j) + """, """ + i.attrib['pin'][:1] + """, """ + i.attrib['pin'][1:] + """) \\
"""
			j+=1
	return [conf, ""]

def module_button(module, conf):
	code = ""
	if conf == "":
		conf = """#define BUTTON_TABLE \\
"""
	else:
		conf += """        ID(""" + module.attrib['id']  + """) \\
"""
		j=0
		for i in module:
			d=depth(i)
			conf += """        ENTRY(""" + str(j) + """, """ + i.attrib['pin'][:1] + """, """ + i.attrib['pin'][1:] + """) \\
"""
			code += """void button_""" + i.attrib['pin'] + """(struct button_sub *el, uint8_t l)
{
#define DIMMER(a, b) \
        el->dimmer.id = a; \
        el->dimmer.sub = b; \
        el->dimmer.status = START_DIMMING;

	if (l) {
		switch (el->count) {
"""
			for k in i.iterfind("short"):
				c_node = k.find("code")
				if c_node != None:
					code += """		case """ + str(depth(k)-d) + """:""" + c_node.text + """break;
"""

			code += """		default:
			break;
		}
	} else {
		switch (el->count) {
"""
			for k in i.iterfind("long"):
				c_node = k.find("code")
				if c_node != None:
					code += """		case """ + str(depth(k)-d-1) + """:""" + c_node.text + """break;
"""
			code += """		default:
			break;
		}
	}
}
"""
			j+=1
# iterate over all children with level indicator
	return [conf, code]

if len(sys.argv) != 4:
	eprint("Usage: %s [XMLSchema] [Configuration] [C-Code Template]" % (argv[0]))
	sys.exit(-1)

xsd = open(argv[1], 'r')
schema = etree.XMLSchema(etree.parse(xsd))

xml = open(argv[2], 'r')
data = etree.parse(xml)

template = open(argv[3], 'r')

if schema.validate(data) == False:
	eprint("Validation of configuration failed")
	sys.exit(-1)

device = data.findall(".//device")

module_handlers = {
	"pwm": module_pwm,
	"output": module_output,
	"button": module_button,
}

for i in device:
	template.seek(0)
	c_file = open("../src/" + i.attrib['name'] + ".c", 'w')
	h_file = open("../src/" + i.attrib['name'] + ".h", 'w')
	c_file.write(template.read())
	conf = """#ifndef CONFIG_H__
#define CONFIG_H__
"""
	code = ""
	for j in module_handlers:
		tmp = module_handlers[j]("", "")
		for k in i.findall(".//" + j):
			tmp = module_handlers[j](k, tmp[0])
			code += tmp[1]
		conf += tmp[0][:-3] + "\n"
	conf += """#endif"""
	c_file.write(code)
	h_file.write(conf)
	c_file.close()
	h_file.close()

xsd.close()
xml.close()
template.close()
