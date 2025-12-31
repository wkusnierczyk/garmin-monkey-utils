import Toybox.Lang;


(:public)
module MonkeyUtils {

    /**
     * Utilities for manipulating and parsing String objects.
     */
    (:public)
    module StringUtils {
        
        /**
         * Splits a string by a delimiter and returns an Array of substrings.
         * This operation is eager and will allocate memory for the entire result array immediately.
         *
         * @param string The string to split.
         * @param delimiter The string pattern to split by. (Note: the 'pattern' must match literally.)
         * @return An Array of Strings containing the split parts.
         */
        (:public)
        public function split(string as String, delimiter as String) as Array<String> {
            var result = [] as Array<String>;
            var current = string;
            
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

        /**
         * Abstract base class defining the contract for string splitters.
         * Allows for interchangeable use of Eager vs Lazy splitting strategies.
         */
        (:public)
        class Splitter {
            
            var _string as String;
            var _delimiter as String;
            
            /**
             * Constructor.
             * @param string The string to split.
             * @param delimiter The delimiter to split by.
             */
            public function initialize(string as String, delimiter as String) {
                self._string = string;
                self._delimiter = delimiter;
            }

            /**
             * Checks if there are more tokens available.
             * @return true if more tokens exist, false otherwise.
             */
            (:public)
            public function hasNext() as Boolean {
                return false;
            }

            /**
             * Advances to the next token.
             * @return The next token string, or null if end of string is reached.
             */
            (:public)
            public function next() as String or Null {
                return null;
            }

            /**
             * Returns the current token without advancing.
             * @return The current token string. Returns null if no token is available (next() has not been called yet, or has been exhausted).
             */
            (:public)
            public function current() as String or Null {
                return null;
            }

            /**
             * Resets the splitter to the beginning of the string. After reset, current() returns null until next() is called.
             * @return The Splitter instance (for chaining).
             */
            (:public)
            public function reset() as Splitter {
                return self;
            }

        }

        /**
         * EagerSplitter implementation.
         * * Splits the entire string upon initialization and stores it in an Array.
         * PROS: Fast iteration after initialization.
         * CONS: Highest peak memory usage (stores Array structure + all substrings simultaneously).
         */        
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
            public function hasNext() as Boolean {
                return (_index + 1) < _array.size();
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

        /**
         * LazySplitter implementation.
         * * Parses the string one token at a time as next() is called.
         * PROS: Avoids allocating the full Array structure. Memory usage decreases as you iterate.
         * CONS: Higher CPU cost (creates new substring objects for the 'remainder' at every step).
         */
        (:public)
        class LazySplitter extends Splitter {

            private var _current as String;
            private var _last as String or Null;

            // Fixed typo: delimier -> delimiter
            (:public)
            public function initialize(string as String, delimiter as String) {
                Splitter.initialize(string, delimiter);
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
                    _last = result; 
                    return result;
                }
                var result = _current.substring(0, index);
                _last = result;
                // Allocation Note: This creates a new string for the remainder
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