/* Copyright 2017 R. Thomas
 * Copyright 2017 Quarkslab
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#include "LIEF/Abstract.hpp"
#include "LIEF/visitors/json.hpp"
#include "LIEF/Abstract/EnumToString.hpp"

#include "LIEF/PE/json.hpp"
#include "LIEF/ELF/json.hpp"

#include "LIEF/config.h"

namespace LIEF {

json to_json(const Visitable& v) {
  json node;
#if defined(LIEF_PE_SUPPORT)
  PE::JsonVisitor pe_visitor{node};
  pe_visitor(v);
  node = pe_visitor.get();
#endif

#if defined(LIEF_ELF_SUPPORT)
  ELF::JsonVisitor elf_visitor{node};
  elf_visitor(v);
  node = elf_visitor.get();
#endif
  return node;
}

std::string to_json_str(const Visitable& v) {
  return to_json(v).dump();
}

JsonVisitor::JsonVisitor(void) :
  node_{}
{}

JsonVisitor::JsonVisitor(const json& node) :
  node_{node}
{}

JsonVisitor::JsonVisitor(const JsonVisitor&)            = default;
JsonVisitor& JsonVisitor::operator=(const JsonVisitor&) = default;

const json& JsonVisitor::get(void) const {
  return this->node_;
}

}

