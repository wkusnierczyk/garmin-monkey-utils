import Toybox.Lang;


(:public)
module MonkeyUtils {

    // Utilities for working with String objects
    (:public)
    module StringUtils {
        
        // Split a string by a delimiter and return an Array of substrings
        (:public)
        public function split(string as String, delimiter as String) {
            
            // An array to grow as the input is processed
            var result = [];

            // A string to shring as the input is processed
            var current = string;

            // Iterate over the input as long as the delimiter is found
            while (current.length() > 0) {
                var index = current.find(delimiter);
                if (index == null) {
                    result.add(current);
                    break;
                }
                var substring = current.substring(0, index);
                result.add(substring);
                current = current.substring(index + delimiter.length(), current.length());
            }
            return result;
        }

        // Abstract class defining the functionality of a splitter
        (:public)
        class Splitter {
            
            var _string as String;
            var _delimiter as String;
            
            public function initialize(string as String, delimiter as String) {
                self._string = string;
                self._delimiter = delimiter;
            }

            (:public)
            public function hasNext() as Boolean {
                return false;
            }

            (:public)
            public function next() as String or Null {
                return null;
            }

            (:public)
            public function current() as String or Null {
                return null;
            }

            (:public)
            public function reset() as Splitter {
                return self;
            }

        }

        (:public)
        class EagerSplitter extends Splitter {

            var _array as Array<String>;
            var _index as Number;

            (:public)
            public function initialize(string as String, delimiter as String) {
                Splitter.initialize(string, delimiter);
                _array = StringUtils.split(string, delimiter);
                _index = -1;
            }

            (:public)
            public function next() {
                ++_index;
                if (_index >= _array.size()) {
                    return null;
                }
                return _array[_index];
            }

            (:public)
            public function current() {
                if (_index < 0 or _index >= _array.size()) {
                    return null;
                }
                return _array[_index];
            }

            (:public)
            public function reset() {
                _index = -1;
                return self;
            }

        }

        (:public)
        class LazySplitter extends Splitter {

            private var _current as String;
            private var _last as String or Null;

            (:public)
            public function initialize(string as String, delimier as String) {
                Splitter.initialize(string, delimier);
                _current = _string;
                _last = null;
            }

            (:public)
            public function hasNext() as Boolean {
                return _current.length() > 0;
            }

            (:public)
            public function next() as String or Null {
                var index = _current.find(_delimiter);
                if (index == null) {
                    var result = _current;
                    _current = "";
                    return result;
                }
                var result = _current.substring(0, index);
                _last = result;
                _current = _current.substring(index + _delimiter.length(), _current.length());
                return result;
            }

            (:public)
            public function current() as String or Null {
                return _last;
            }

            (:public)
            public function reset() {
                _current = _string;
                _last = null;
                return self;
            }
            
        }


    }

}