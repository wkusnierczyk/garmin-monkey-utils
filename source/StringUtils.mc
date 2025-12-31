import Toybox.Lang;

using MonkeyUtils.ContainerUtils;


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
         * @param delimiter The string pattern to split by.
         * @return An Array of Strings containing the split parts.
         */
        (:public)
        public function split(string as String, delimiter as String) as Array<String> {
            var result = [] as Array<String>;
            var current = string;
            var delimiterLength = delimiter.length();
            
            // Handle empty string case explicitly
            if (string.length() == 0) {
                return result;
            }

            var index = current.find(delimiter);
            while (index != null) {
                // Add the part before the delimiter (can be empty)
                result.add(current.substring(0, index));
                
                // Advance current past the delimiter
                current = current.substring(index + delimiterLength, current.length());
                
                // Find the next occurrence
                index = current.find(delimiter);
            }
            
            // ALWAYS add the remaining part (even if it's an empty string)
            // This ensures "a:" returns ["a", ""]
            result.add(current);
            return result;
        }

        /**
         * Abstract base class defining the contract for string splitters.
         */
        (:public)
        class Splitter extends ContainerUtils.Iterator {
            
            var _string as String;
            var _delimiter as String;
            
            /**
             * Constructor.
             * @param string The string to split.
             * @param delimiter The delimiter to split by.
             */
            public function initialize(string as String, delimiter as String) {
                Iterator.initialize();
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
             * @return The current token string, or null if unavailable.
             */
            (:public)
            public function current() as String or Null {
                return null;
            }

            /**
             * Resets the splitter to the beginning of the string.
             * @return The Splitter instance (for chaining).
             */
            (:public)
            public function reset() {
                return self;
            }

        }

        /**
         * EagerSplitter implementation.
         * Splits the entire string upon initialization and stores it in an Array.
         * PROS: Fast iteration after initialization.
         * CONS: Highest peak memory usage.
         */        
        (:public)
        class EagerSplitter extends Splitter {

            var _array as Array<String>;
            var _index as Number;

            (:public)
            public function initialize(string as String, delimiter as String) {
                Splitter.initialize(string, delimiter);
                // Uses the updated static split(), so it automatically handles edge cases correctly
                _array = StringUtils.split(string, delimiter);
                _index = -1;
            }

            (:public)
            public function hasNext() as Boolean {
                return (_index + 1) < _array.size();
            }
            
            (:public)
            public function next() as String or Null {
                ++_index;
                if (_index >= _array.size()) {
                    return null;
                }
                return _array[_index];
            }

            (:public)
            public function current() as String or Null {
                if (_index < 0 or _index >= _array.size()) {
                    return null;
                }
                return _array[_index];
            }

            (:public)
            public function reset() as Splitter {
                _index = -1;
                return self;
            }

        }

        /**
         * LazySplitter implementation.
         * Parses the string one token at a time as next() is called.
         * PROS: Low memory usage.
         * CONS: Higher CPU cost per step.
         */
        (:public)
        class LazySplitter extends Splitter {

            // We use _remainder to track what is left of the string.
            // If _remainder is null, it means we have finished.
            private var _remainder as String or Null;
            private var _lastToken as String or Null;

            (:public)
            public function initialize(string as String, delimiter as String) {
                Splitter.initialize(string, delimiter);
                _lastToken = null;
                
                // If input is empty, we are finished immediately (to match split() behavior)
                if (string.length() == 0) {
                    _remainder = null;
                } else {
                    _remainder = string;
                }
            }

            (:public)
            public function hasNext() as Boolean {
                // As long as _remainder is not null, we have at least one more token 
                // (even if that token is an empty string)
                return _remainder != null;
            }

            (:public)
            public function next() as String or Null {
                if (_remainder == null) {
                    return null;
                }

                var index = _remainder.find(_delimiter);
                var result;

                if (index == null) {
                    // Case: No more delimiters. The remainder IS the final token.
                    result = _remainder;
                    // We are now exhausted.
                    _remainder = null;
                } else {
                    // Case: Found a delimiter. Extract token up to the delimiter.
                    result = _remainder.substring(0, index);
                    // Advance remainder past the delimiter.
                    _remainder = _remainder.substring(index + _delimiter.length(), _remainder.length());
                }

                _lastToken = result;
                return result;
            }

            (:public)
            public function current() as String or Null {
                return _lastToken;
            }

            (:public)
            public function reset() as Splitter {
                _lastToken = null;
                if (_string.length() == 0) {
                    _remainder = null;
                } else {
                    _remainder = _string;
                }
                return self;
            }

        }

    }

}