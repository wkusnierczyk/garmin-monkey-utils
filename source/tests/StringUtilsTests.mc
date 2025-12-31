import Toybox.Lang;
import Toybox.Test;
import Toybox.Application;


(:public)
module MonkeyUtils {

    (:public)
    module StringUtils {

        (:public)
        module StringSplitterTests {

            const TEST_NAME_KEY = "name";
            const TEST_INPUT_KEY = "input";
            const TEST_DELIMITER_KEY = "delimiter";
            const TEST_EXPECTED_KEY = "expected";

            class StringUtilsSplitAdapter {
                public function split(input, delimiter) {
                    return StringUtils.split(input, delimiter);
                }
            }

            class StringUtilsEagerSplitterAdapter {
                public function split(input, delimiter) {
                    var splitter = new StringUtils.EagerSplitter(input, delimiter);
                    var result = [];
                    while (splitter.hasNext()) {
                        result.add(splitter.next());
                    }
                    return result;
                }
            }

            class StringUtilsLazySplitterAdapter {
                public function split(input, delimiter) {
                    var splitter = new StringUtils.LazySplitter(input, delimiter);
                    var result = [];
                    while (splitter.hasNext()) {
                        result.add(splitter.next());
                    }
                    return result;
                }
            }

            function testSplitter(splitter as String, callback as Method, test as Dictionary, logger) as Boolean {
                var name = test[TEST_NAME_KEY] as String;
                var input = test[TEST_INPUT_KEY] as String;
                var delimiter = test[TEST_DELIMITER_KEY] as String;
                var expected = test[TEST_EXPECTED_KEY] as Array;
                var actual = callback.invoke(input, delimiter);
                if (!ArrayUtils.equal(expected, actual)) {
                    var message = Lang.format("$1$ failed on test $2$", [splitter, name]);
                    logger.debug(message);
                    return false;
                }
                var message = Lang.format("$1$ passed on test $2$", [splitter, name]);
                logger.debug(message);
                return true;
            }        

            (:test)
            function test(logger as Test.Logger) as Boolean {

                var passed = true;
                
                var tests = Application.loadResource(Rez.JsonData.StringUtilsSplitTestCases) as Array;
                var splitters = [
                    { :name => "StringUtils.split",
                    :callback => new StringUtilsSplitAdapter().method(:split) },
                    { :name => "StringUtils.EagerSplitter",
                    :callback => new StringUtilsEagerSplitterAdapter().method(:split) },
                    { :name => "StringUtils.LazySplitter",
                    :callback => new StringUtilsLazySplitterAdapter().method(:split) }];

                for (var i = 0; i < splitters.size(); ++i) {
                    var splitter = splitters[i] as Dictionary;
                    for (var j = 0; j < tests.size(); ++j) {
                        var test = tests[j] as Dictionary;
                        passed = passed and testSplitter(splitter[:name], splitter[:callback], test, logger);
                    }
                }
                return passed;

            }

        }
        
    }

}