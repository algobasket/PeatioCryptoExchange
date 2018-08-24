#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Documentation for Mako templates:
# http://www.makotemplates.org/docs/syntax.html

import os, sys, re

sys.path.append(os.path.join("codegen", "rabbitmq-codegen"))

from amqp_codegen import *
try:
    from mako.template import Template
except ImportError:
    print "Mako isn't installed. Please install mako via pip or similar."
    sys.exit(1)

# main class
class AmqpSpecObject(AmqpSpec):
    IGNORED_CLASSES = ["access"]
    IGNORED_FIELDS = {
        'ticket': 0,
        'capabilities': '',
        'insist' : 0,
        'out_of_band': '',
        'known_hosts': '',
    }

    def __init__(self, path):
        AmqpSpec.__init__(self, path)

        def extend_field(field):
            field.ruby_name = re.sub("[- ]", "_", field.name)
            field.type = self.resolveDomain(field.domain)
            field.ignored = bool(field.name in self.__class__.IGNORED_FIELDS) # I. e. deprecated

        for klass in self.classes:
            klass.ignored = bool(klass.name in self.__class__.IGNORED_CLASSES)

            for field in klass.fields:
                extend_field(field)

            for method in klass.methods:
                for field in method.arguments:
                    extend_field(field)

        self.classes = filter(lambda klass: not klass.ignored, self.classes)

original_init = AmqpEntity.__init__
def new_init(self, arg):
    original_init(self, arg)
    constant_name = ""
    for chunk in self.name.split("-"):
        constant_name += chunk.capitalize()
    self.constant_name = constant_name
AmqpEntity.__init__ = new_init

# method.accepted_by("server")
# method.accepted_by("client", "server")
accepted_by_update = json.loads(file("codegen/amqp_0.9.1_changes.json").read())

def accepted_by(self, *receivers):
    def get_accepted_by(self):
        try:
            return accepted_by_update[self.klass.name][self.name]
        except KeyError:
            return ["server", "client"]

    actual_receivers = get_accepted_by(self)
    return all(map(lambda receiver: receiver in actual_receivers, receivers))

AmqpMethod.accepted_by = accepted_by

def convert_value_to_ruby(value):
    values = {None: "nil", False: "false", True: "true", "": "EMPTY_STRING"}

    try:
        return values[value]
    except:
        return value.__repr__()

def convert_to_ruby(field):
    name = re.sub("-", "_", field.name) # TODO: use ruby_name
    if name == "ticket":
        return "%s = %s" % (name, field.defaultvalue) # we want to keep it as an int, not as a boolean
    else:
        return "%s = %s" % (name, convert_value_to_ruby(field.defaultvalue))

def not_ignored_args(self):
    if self.hasContent:
        return ["payload", "user_headers"] + map(lambda argument: argument.ruby_name, filter(lambda argument: not argument.ignored, self.arguments)) + ["frame_size"]
    else:
        return map(lambda argument: argument.ruby_name, filter(lambda argument: not argument.ignored, self.arguments))

AmqpMethod.not_ignored_args = not_ignored_args

def ignored_args(self):
    return filter(lambda argument: argument.ignored, self.arguments)

AmqpMethod.ignored_args = ignored_args

# helpers
def to_ruby_name(name):
    return re.sub("[- ]", "_", name)

def to_ruby_class_name(name):
    parts = re.split("[- ]", name)
    ruby_class_name = ""
    for part in parts:
        ruby_class_name = ruby_class_name + part[0].upper() + part[1:].lower()
    return ruby_class_name

def params(self):
    buffer = []
    for f in self.arguments:
        buffer.append(convert_to_ruby(f))
    if self.hasContent:
        buffer.append("user_headers = nil")
        buffer.append("payload = \"\"")
        buffer.append("frame_size = nil")
    return buffer

AmqpMethod.params = params

def args(self):
    return map(lambda item: item.split(" ")[0], self.params())

AmqpMethod.args = args

def binary(self):
    method_id = self.klass.index << 16 | self.index
    return "0x%08X # %i, %i, %i" % (method_id, self.klass.index, self.index, method_id)

AmqpMethod.binary = binary

# helpers
def render(path, **context):
    file = open(path)
    template = Template(file.read())
    return template.render(**context)

def generateMain(type):
    def main(json_spec_path):
        spec = AmqpSpecObject(json_spec_path)
        spec.type = type
        print render("codegen/protocol.rb.pytemplate", spec = spec)

    return main

if __name__ == "__main__":
    do_main_dict({"client": generateMain("client")})
