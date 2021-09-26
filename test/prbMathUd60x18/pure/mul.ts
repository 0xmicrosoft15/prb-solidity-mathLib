import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { E, HALF_SCALE, MAX_UD60x18, MAX_WHOLE_UD60x18, PI, SQRT_MAX_UD60x18 } from "../../../helpers/constants";
import { PRBMathErrors } from "../../shared/errors";
import { mul } from "../../shared/mirrors";

export default function shouldBehaveLikeMul(): void {
  context("when one of the operands is zero", function () {
    const testSets = [
      [Zero, fp(MAX_UD60x18)],
      [Zero, fp("0.5")],
      [fp("0.5"), Zero],
      [fp(MAX_UD60x18), Zero],
    ];

    forEach(testSets).it("takes %e and %e and returns 0", async function (x: BigNumber, y: BigNumber) {
      const expected: BigNumber = Zero;
      expect(expected).to.equal(await this.contracts.prbMathUd60x18.doMul(x, y));
      expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doMul(x, y));
    });
  });

  context("when neither of the operands is zero", function () {
    context("when the result overflows", function () {
      const testSets = [
        [fp(SQRT_MAX_UD60x18).add(1), fp(SQRT_MAX_UD60x18).add(1)],
        [fp(MAX_WHOLE_UD60x18), fp(MAX_WHOLE_UD60x18)],
        [fp(MAX_UD60x18), fp(MAX_UD60x18)],
      ];

      forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
        await expect(this.contracts.prbMathUd60x18.doMul(x, y)).to.be.revertedWith(
          PRBMathErrors.MulDivFixedPointOverflow,
        );
        await expect(this.contracts.prbMathUd60x18Typed.doMul(x, y)).to.be.revertedWith(
          PRBMathErrors.MulDivFixedPointOverflow,
        );
      });
    });

    context("when the result does not overflow", function () {
      const testSets = [
        [fp("1e-18"), fp("1e-18")],
        [fp("6e-18"), fp("0.1")],
        [fp("1e-9"), fp("1e-9")],
        [fp("1e-5"), fp("1e-5")],
        [fp("0.001"), fp("0.01")],
        [fp("0.01"), fp("0.05")],
        [fp("1"), fp("1")],
        [fp("2.098"), fp("1.119")],
        [fp(PI), fp(E)],
        [fp("18.3"), fp("12.04")],
        [fp("314.271"), fp("188.19")],
        [fp("9817"), fp("2348")],
        [fp("12983.989"), fp("782.99")],
        [fp("1e18"), fp("1e6")],
        [fp(SQRT_MAX_UD60x18), fp(SQRT_MAX_UD60x18)],
        [fp(MAX_WHOLE_UD60x18), fp("1e-18")],
        [fp(MAX_WHOLE_UD60x18), fp("0.01")],
        [fp(MAX_WHOLE_UD60x18), fp("0.5")],
        [fp(MAX_UD60x18).sub(fp(HALF_SCALE)), fp("1e-18")],
        [fp(MAX_UD60x18), fp("0.01")],
        [fp(MAX_UD60x18), fp("0.5")],
      ];

      forEach(testSets).it(
        "takes %e and %e and returns the correct value",
        async function (x: BigNumber, y: BigNumber) {
          const expected: BigNumber = mul(x, y);
          expect(expected).to.equal(await this.contracts.prbMathUd60x18.doMul(x, y));
          expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doMul(x, y));
        },
      );
    });
  });
}
