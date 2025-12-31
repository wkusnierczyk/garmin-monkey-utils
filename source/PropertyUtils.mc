using Toybox.Application.Properties;

import Toybox.Application;
import Toybox.Lang;


(:public)
module MonkeyUtils {

    (:public)
    module PropertyUtils {

        (:public)
        public function getPropertyElseDefault(propertyName as PropertyKeyType, defaultValue as PropertyValueType) 
                as PropertyValueType {
            var value;
            try {
                value = Properties.getValue(propertyName);
                if (value == null) {
                    value = defaultValue;
                }
            } catch (e) {
                value = defaultValue;
            }
            return value;
        }

    }

}