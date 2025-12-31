import Toybox.Lang;

(:public)
module MonkeyUtils {

    (:public)
    module ContainerUtils {

        /**
        * A standard interface for iterating over collections.
        * Allows generic algorithms to consume data from Arrays, Splitters, or custom lists interchangeably.
        */
        (:public)
        class Iterator {
            
            (:public)
            public function initialize() {
            }

            /**
            * Checks if there are more elements to iterate over.
            * @return true if there are more elements, false otherwise.
            */
            (:public)
            public function hasNext() as Boolean {
                return false;
            }

            /**
            * Retrieves the next element in the iteration.
            * @return The next element, or null if iteration is finished.
            */
            (:public)
            public function next() {
                return null;
            }

            /**
            * Resets the iterator to the beginning of the collection.
            * @return The Iterator instance (for chaining).
            */
            (:public)
            public function reset() {
                return self;
            }
        }

    }

}