import Toybox.Lang;

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

    }
    
}