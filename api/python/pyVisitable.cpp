#include "pyLIEF.hpp"

void init_LIEF_Visitable_class(py::module& m) {
  py::class_<LIEF::Visitable>(m, "Visitable");
}
