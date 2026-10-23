import unittest
from tools.rv32i_reference import RV32I
from tools.compare_traces import compare


class RV32ITests(unittest.TestCase):
    def test_arithmetic_memory_and_x0(self):
        words = [0x00500093, 0x00700113, 0x002081B3, 0x00302023,
                 0x00002203, 0x00100013]
        model = RV32I(words)
        trace = model.run()
        self.assertEqual(len(trace), 6)
        self.assertEqual(model.reg[3], 12)
        self.assertEqual(model.reg[4], 12)
        self.assertEqual(model.reg[0], 0)
        self.assertEqual(model.load(0, 4, False), 12)

    def test_branch_skips_instruction(self):
        # beq x1,x1,+8 skips the addi x2,x0,99 instruction.
        words = [0x00100093, 0x00108463, 0x06300113, 0x00200193]
        model = RV32I(words)
        model.run()
        self.assertEqual(model.reg[2], 0)
        self.assertEqual(model.reg[3], 2)

    def test_invalid_instruction_is_rejected(self):
        with self.assertRaisesRegex(ValueError, "Unsupported instruction"):
            RV32I([0]).run()

    def test_trace_checker_detects_mismatch(self):
        expected = [{"pc": "00000000", "instruction": "00500093", "rd": "1", "value": "00000005"}]
        observed = [{**expected[0], "value": "00000006"}]
        self.assertEqual(compare(expected, expected), [])
        self.assertIn("Step 1", compare(expected, observed)[0])


if __name__ == "__main__":
    unittest.main()
