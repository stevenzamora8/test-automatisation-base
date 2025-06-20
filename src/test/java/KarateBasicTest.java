import static org.junit.jupiter.api.Assertions.assertEquals;
import org.junit.jupiter.api.Test;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;

class KarateBasicTest {
    static {
        System.setProperty("karate.ssl", "true");
    }

    @Test
    void testMarvelCharactersAPI() {
        Results results = Runner.path("classpath:karate-test.feature").parallel(1);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
