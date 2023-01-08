// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "src/UD60x18.sol";
import { UD60x18_Test } from "../../UD60x18.t.sol";

contract CeilTest is UD60x18_Test {
    function test_Ceil_Zero() external {
        UD60x18 x = ZERO;
        UD60x18 actual = ceil(x);
        UD60x18 expected = ZERO;
        assertEq(actual, expected);
    }

    modifier NotZero() {
        _;
    }

    function test_RevertWhen_GreaterThanMaxPermitted() external NotZero {
        UD60x18 x = MAX_WHOLE_UD60x18.add(ud(1));
        vm.expectRevert(abi.encodeWithSelector(PRBMathUD60x18__CeilOverflow.selector, x));
        ceil(x);
    }

    modifier LessThanOrEqualToMaxWholeUD60x18() {
        _;
    }

    function ceil_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.1e18, expected: 1e18 }));
        sets.push(set({ x: 0.5e18, expected: 1e18 }));
        sets.push(set({ x: 1e18, expected: 1e18 }));
        sets.push(set({ x: 1.125e18, expected: 2e18 }));
        sets.push(set({ x: 2e18, expected: 2e18 }));
        sets.push(set({ x: PI, expected: 4e18 }));
        sets.push(set({ x: 4.2e18, expected: 5e18 }));
        sets.push(set({ x: 1e24, expected: 1e24 }));
        sets.push(set({ x: MAX_WHOLE_UD60x18, expected: MAX_WHOLE_UD60x18 }));
        return sets;
    }

    function test_Ceil() external parameterizedTest(ceil_Sets()) NotZero LessThanOrEqualToMaxWholeUD60x18 {
        UD60x18 actual = ceil(s.x);
        assertEq(actual, s.expected);
    }
}
