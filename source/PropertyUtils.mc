using Toybox.Application.Properties; 

import Toybox.Application;
import Toybox.Lang;

using Toybox.Test;


(:public)
module MonkeyUtils {

    /**
     * Utilities for manipulating Properties.
     */
    (:public)
    module PropertyUtils {

        /**
         * Retrieves a property value from Application.Properties, returning a default
         * value if the property is null or if an exception occurs.
         *
         * @param propertyName The key of the property to retrieve.
         * @param defaultValue The value to return if retrieval fails or is null.
         * @return The property value or the default value.
         */
        (:public)
        public function getPropertyElseDefault(propertyName, defaultValue) {
            try {
                var value = Properties.getValue(propertyName);
                return (value == null) ? defaultValue : value;
            } catch (e) {
                // Catching errors (like Invalid Key) to ensure app stability
                return defaultValue;
            }
        }
    }
}