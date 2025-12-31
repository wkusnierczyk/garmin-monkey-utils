import Toybox.Lang;
import Toybox.Test;
import Toybox.Application;


(:public)
module MonkeyUtils {

    (:public)
    module ArrayUtils {

        (:public)
        module ArrayEqualityTests {

            const TEST_NAME_KEY = "name";
            const TEST_INPUT_KEY = "input";
            const TEST_DELIMITER_KEY = "delimiter";
            const TEST_EXPECTED_KEY = "expected";
            const TEST_INPUT_THIS_KEY = "this";
            const TEST_INPUT_THAT_KEY = "that";

            (:test)
            function test(logger as Test.Logger) as Boolean {

                var passed = true;
                
                var tests = Application.loadResource(Rez.JsonData.ArrayUtilsEqualTestCases) as Array; 

                for (var i = 0; i < tests.size(); ++i) {
                    var test = tests[i] as Dictionary;
                    var name = test[TEST_NAME_KEY] as String;
                    var input = test[TEST_INPUT_KEY] as Array;
                    var this = input[TEST_INPUT_THIS_KEY] as Array;
                    var that = input[TEST_INPUT_THAT_KEY] as Array;
                    var expected = test[TEST_EXPECTED_KEY] as Boolean;
                    var actual = ArrayUtils.equal(this, that) as Boolean;
                    if (actual != expected) {
                        var message = Lang.format("$1$ failed on test $2$", ["ArrayUtils.equal", name]);
                        logger.debug(message);
                        passed = false;
                    } else {
                        var message = Lang.format("$1$ passed on test $2$", ["ArrayUtils.equal", name]);
                        logger.debug(message);
                    }
                }

                return passed;

            }
            
        }


    }

}