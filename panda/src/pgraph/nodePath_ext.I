/**
 * PANDA 3D SOFTWARE
 * Copyright (c) Carnegie Mellon University.  All rights reserved.
 *
 * All use of this software is subject to the terms of the revised BSD
 * license.  You should have received a copy of this license along
 * with this source code in a file named "LICENSE."
 *
 * @file nodePath_ext.I
 * @author rdb
 * @date 2013-12-09
 */

#include "pandaNode_ext.h"

/**
 * Fills the given vector up with the list of Python tags on this PandaNode.
 *
 * It is the user's responsibility to ensure that the keys vector is empty
 * before making this call; otherwise, the new files will be appended to it.
 */
INLINE void Extension<NodePath>::
get_python_tag_keys(vector_string &keys) const {
  nassertv_always(!_this->is_empty());
  invoke_extension(_this->node()).get_python_tag_keys(keys);
}

/**
 * This variant on get_tag_keys returns a Python list of strings.  Returns
 * None if the NodePath is empty.
 */
INLINE PyObject *Extension<NodePath>::
get_tag_keys() const {
  // An empty NodePath returns None
  if (_this->is_empty()) {
    Py_INCREF(Py_None);
    return Py_None;
  }
  return invoke_extension(_this->node()).get_tag_keys();
}

/**
 * This variant on get_python_tag_keys returns a Python list of strings.
 * Returns None if the NodePath is empty.
 */
INLINE PyObject *Extension<NodePath>::
get_python_tag_keys() const {
  // An empty NodePath returns None
  if (_this->is_empty()) {
    Py_INCREF(Py_None);
    return Py_None;
  }
  return invoke_extension(_this->node()).get_python_tag_keys();
}

/**
 * Associates an arbitrary Python object with a user-defined key which is
 * stored on the node.  This object has no meaning to Panda; but it is stored
 * indefinitely on the node until it is requested again.
 *
 * Each unique key stores a different Python object.  There is no effective
 * limit on the number of different keys that may be stored or on the nature
 * of any one key's object.
 */
INLINE void Extension<NodePath>::
set_python_tag(const string &key, PyObject *value) {
  nassertv_always(!_this->is_empty());
  invoke_extension(_this->node()).set_python_tag(key, value);
}

/**
 * Retrieves the Python object that was previously set on this node for the
 * particular key, if any.  If no object has been previously set, returns
 * None.  See also get_net_python_tag().
 */
INLINE PyObject *Extension<NodePath>::
get_python_tag(const string &key) const {
  // An empty NodePath quietly returns no tags.  This makes
  // get_net_python_tag() easier to implement.
  if (_this->is_empty()) {
    Py_INCREF(Py_None);
    return Py_None;
  }
  return invoke_extension(_this->node()).get_python_tag(key);
}

/**
 * Returns true if a Python object has been defined on this node for the
 * particular key (even if that value is the empty string), or false if no
 * value has been set.  See also has_net_python_tag().
 */
INLINE bool Extension<NodePath>::
has_python_tag(const string &key) const {
  // An empty NodePath quietly has no tags.  This makes has_net_python_tag()
  // easier to implement.
  if (_this->is_empty()) {
    return false;
  }
  return invoke_extension(_this->node()).has_python_tag(key);
}

/**
 * Removes the Python object defined for this key on this particular node.
 * After a call to clear_python_tag(), has_python_tag() will return false for
 * the indicated key.
 */
INLINE void Extension<NodePath>::
clear_python_tag(const string &key) {
  nassertv_always(!_this->is_empty());
  invoke_extension(_this->node()).clear_python_tag(key);
}

/**
 * Returns the Python object that has been defined on this node, or the
 * nearest ancestor node, for the indicated key.  If no value has been defined
 * for the indicated key on any ancestor node, returns None.  See also
 * get_python_tag().
 */
INLINE PyObject *Extension<NodePath>::
get_net_python_tag(const string &key) const {
  NodePath tag_np = find_net_python_tag(key);
  return invoke_extension(&tag_np).get_python_tag(key);
}

/**
 * Returns true if the indicated Python object has been defined on this node
 * or on any ancestor node, or false otherwise.  See also has_python_tag().
 */
INLINE bool Extension<NodePath>::
has_net_python_tag(const string &key) const {
  return !find_net_python_tag(key).is_empty();
}
