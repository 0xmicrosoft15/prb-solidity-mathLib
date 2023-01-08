// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import "src/SD59x18.sol";
import { SD59x18_Test } from "../../SD59x18.t.sol";

contract Frac_Test is SD59x18_Test {
    function test_Frac_Zero() external {
        SD59x18 x = ZERO;
        SD59x18 actual = frac(x);
        SD59x18 expected = ZERO;
        assertEq(actual, expected);
    }

    modifier NotZero() {
        _;
    }

    function negative_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18, expected: -0.792003956564819968e18 }));
        sets.push(set({ x: MIN_WHOLE_SD59x18, expected: 0 }));
        sets.push(set({ x: -1e24, expected: 0 }));
        sets.push(set({ x: -4.2e18, expected: -0.2e18 }));
        sets.push(set({ x: NEGATIVE_PI, expected: -0.141592653589793238e18 }));
        sets.push(set({ x: -2e18, expected: 0 }));
        sets.push(set({ x: -1.125e18, expected: -0.125e18 }));
        sets.push(set({ x: -1e18, expected: 0 }));
        sets.push(set({ x: -0.5e18, expected: -0.5e18 }));
        sets.push(set({ x: -0.1e18, expected: -0.1e18 }));
        return sets;
    }

    function test_Frac_Negative() external parameterizedTest(negative_Sets()) NotZero {
        SD59x18 actual = frac(s.x);
        assertEq(actual, s.expected);
    }

    function positive_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.1e18, expected: 0.1e18 }));
        sets.push(set({ x: 0.5e18, expected: 0.5e18 }));
        sets.push(set({ x: 1e18, expected: 0 }));
        sets.push(set({ x: 1.125e18, expected: 0.125e18 }));
        sets.push(set({ x: 2e18, expected: 0 }));
        sets.push(set({ x: PI, expected: 0.141592653589793238e18 }));
        sets.push(set({ x: 4.2e18, expected: 0.2e18 }));
        sets.push(set({ x: 1e24, expected: 0 }));
        sets.push(set({ x: MAX_WHOLE_SD59x18, expected: 0 }));
        sets.push(set({ x: MAX_SD59x18, expected: 0.792003956564819967e18 }));
        return sets;
    }

    function test_Frac() external parameterizedTest(positive_Sets()) NotZero {
        SD59x18 actual = frac(s.x);
        assertEq(actual, s.expected);
    }
}
