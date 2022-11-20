// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import {
    E,
    MAX_WHOLE_SD59x18,
    MAX_SD59x18,
    PI,
    PRBMathSD59x18__SqrtOverflow,
    PRBMathSD59x18__SqrtNegativeInput,
    SD59x18,
    ZERO,
    sqrt
} from "src/SD59x18.sol";
import { SD59x18__BaseTest } from "../SD59x18BaseTest.t.sol";

contract SD59x18__SqrtTest is SD59x18__BaseTest {
    SD59x18 internal constant MAX_PERMITTED =
        SD59x18.wrap(57896044618658097711785492504343953926634_992332820282019728);

    function testSqrt__Zero() external {
        SD59x18 x = ZERO;
        SD59x18 actual = sqrt(x);
        SD59x18 expected = ZERO;
        assertEq(actual, expected);
    }

    modifier NotZero() {
        _;
    }

    function testCannotSqrt__Negative() external NotZero {
        SD59x18 x = sd(-1);
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__SqrtNegativeInput.selector, x));
        sqrt(x);
    }

    modifier Positive() {
        _;
    }

    function greaterThanMaxPermittedSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MAX_PERMITTED.add(sd(1)) }));
        sets.push(set({ x: MAX_WHOLE_SD59x18 }));
        sets.push(set({ x: MAX_SD59x18 }));
        return sets;
    }

    function testCannotSqrt__GreaterThanMaxPermitted()
        external
        parameterizedTest(greaterThanMaxPermittedSets())
        NotZero
        Positive
    {
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__SqrtOverflow.selector, s.x));
        sqrt(s.x);
    }

    modifier LessThanOrEqualToMaxPermitted() {
        _;
    }

    function sqrtSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.000000000000000001e18, expected: 0.000000001e18 }));
        sets.push(set({ x: 0.000000000000001e18, expected: 0.000000031622776601e18 }));
        sets.push(set({ x: 1e18, expected: 1e18 }));
        sets.push(set({ x: 2e18, expected: 1_414213562373095048 }));
        sets.push(set({ x: E, expected: 1_648721270700128146 }));
        sets.push(set({ x: 3e18, expected: 1_732050807568877293 }));
        sets.push(set({ x: PI, expected: 1_772453850905516027 }));
        sets.push(set({ x: 4e18, expected: 2e18 }));
        sets.push(set({ x: 16e18, expected: 4e18 }));
        sets.push(set({ x: 1e35, expected: 316227766_016837933199889354 }));
        sets.push(set({ x: 12489131238983290393813_123784889921092801, expected: 111754781727_598977910452220959 }));
        sets.push(
            set({
                x: 1889920002192904839344128288891377_732371920009212883,
                expected: 43473210166640613_973238162807779776
            })
        );
        sets.push(set({ x: 1e58, expected: 1e38 }));
        sets.push(set({ x: 5e58, expected: 223606797749978969640_917366873127623544 }));
        sets.push(set({ x: MAX_PERMITTED, expected: 240615969168004511545_033772477625056927 }));
        return sets;
    }

    function testSqrt() external parameterizedTest(sqrtSets()) NotZero Positive LessThanOrEqualToMaxPermitted {
        SD59x18 actual = sqrt(s.x);
        assertEq(actual, s.expected);
    }
}
