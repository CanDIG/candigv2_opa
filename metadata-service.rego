package metadata

import input
import data.paths

default allow = false

allow = true {
  input.path == paths[_].path
  input.method == paths[_].method
  input.access_level >= paths[_].access_level
}
