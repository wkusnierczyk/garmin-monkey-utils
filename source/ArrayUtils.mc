import Toybox.Lang;

using MonkeyUtils.ContainerUtils;


(:public)
module MonkeyUtils {

    (:public)
    module ArrayUtils {

        /**
         * Compares two arrays for deep content equality.
         * * This function iterates through both arrays and checks if their elements 
         * are equal. It handles nested arrays (recursion), null values, and 
         * standard object equality.
         *
         * @param this The first array to compare
         * @param that The second array to compare
         * @return true if the arrays have the same size and identical content, false otherwise
         */
        (:public)
        public function equal(this as Array, that as Array) as Boolean {
            // Check size first for efficiency
            if (this.size() != that.size()) { 
                return false;
            }
            for (var i = 0; i < this.size(); ++i) {
                var thisElement = this[i];
                var thatElement = that[i];

                // Handle null parity check
                if ((thisElement == null) != (thatElement == null)) { 
                    return false;
                }

                // If both are arrays, perform a recursive deep comparison
                if (thisElement instanceof Array && thatElement instanceof Array) {
                    if (!equal(thisElement, thatElement)) { 
                        return false;
                    }
                } 
                // Handle standard object equality (Strings, Numbers, etc.)
                // Note: We skip the check if both are null because parity was checked above
                else if (thisElement != null && !thisElement.equals(thatElement)) {
                    return false;
                }
            }

            return true;

        }

        /**
         * Creates an Iterator for a standard Array.
         * @param array The array to iterate over.
         * @return A new Iterator instance.
         */
        (:public)
        public function getIterator(array as Array) as ContainerUtils.Iterator {
            return new ArrayIterator(array);
        }

        /**
         * Private implementation of Iterator for Arrays.
         */
        class ArrayIterator extends ContainerUtils.Iterator {
            var _array as Array;
            var _index as Number;

            public function initialize(array as Array) {
                Iterator.initialize();
                _array = array;
                _index = -1;
            }

            public function hasNext() as Boolean {
                return (_index + 1) < _array.size();
            }

            public function next() {
                _index++;
                if (_index < _array.size()) {
                    return _array[_index];
                }
                return null;
            }

            public function reset() as Void {
                _index = -1;
            }
        }

    }

}