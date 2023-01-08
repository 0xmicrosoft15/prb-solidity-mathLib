// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import "src/UD60x18.sol";
import { UD60x18_Test } from "../../UD60x18.t.sol";

contract Floor_Test is UD60x18_Test {
    function test_Floor_Zero() external {
        UD60x18 x = ZERO;
        UD60x18 actual = floor(x);
        UD60x18 expected = ZERO;
        assertEq(actual, expected);
    }

    modifier notZero() {
        _;
    }

    function floor_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.1e18, expected: 0 }));
        sets.push(set({ x: 0.5e18, expected: 0 }));
        sets.push(set({ x: 1e18, expected: 1e18 }));
        sets.push(set({ x: 1.125e18, expected: 1e18 }));
        sets.push(set({ x: 2e18, expected: 2e18 }));
        sets.push(set({ x: PI, expected: 3e18 }));
        sets.push(set({ x: 4.2e18, expected: 4e18 }));
        sets.push(set({ x: 1e24, expected: 1e24 }));
        sets.push(set({ x: MAX_WHOLE_UD60x18, expected: MAX_WHOLE_UD60x18 }));
        sets.push(set({ x: MAX_UD60x18, expected: MAX_WHOLE_UD60x18 }));
        return sets;
    }

    function test_Floor_Positive() external parameterizedTest(floor_Sets()) notZero {
        UD60x18 actual = floor(s.x);
        assertEq(actual, s.expected);
    }
}
