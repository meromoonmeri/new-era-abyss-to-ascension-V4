#!/usr/bin/env python3
from __future__ import annotations

import signal
import unittest

from run_pmdred_eu_pmdo_termination_gate import classify_returncode


class TerminationClassificationTests(unittest.TestCase):
    def test_normal_exit_is_distinct_and_passes(self) -> None:
        result = classify_returncode(0, signal.SIGTERM, False)
        self.assertEqual(result["kind"], "NORMAL_EXIT")
        self.assertEqual(result["result"], "PASS")
        self.assertIsNone(result["exit_signal"])

    def test_expected_term_is_recorded_as_signal_and_passes(self) -> None:
        result = classify_returncode(-signal.SIGTERM, signal.SIGTERM, False)
        self.assertEqual(result["kind"], "EXPECTED_SIGTERM_SIGNAL")
        self.assertEqual(result["result"], "PASS")
        self.assertEqual(result["wait_state"], "SIGNALED")
        self.assertEqual(result["exit_signal"], signal.SIGTERM)
        self.assertFalse(result["segmentation_fault"])

    def test_official_sigint_direct_and_managed_statuses_pass(self) -> None:
        direct = classify_returncode(-signal.SIGINT, signal.SIGINT, False)
        managed = classify_returncode(128 + signal.SIGINT, signal.SIGINT, False)
        self.assertEqual(direct["kind"], "EXPECTED_SIGINT_SIGNAL")
        self.assertEqual(direct["wait_state"], "SIGNALED")
        self.assertEqual(managed["kind"], "EXPECTED_SIGINT_EXIT_CODE")
        self.assertEqual(managed["wait_state"], "EXITED")
        self.assertEqual(direct["result"], managed["result"])
        self.assertEqual(direct["result"], "PASS")

    def test_sigsegv_is_never_hidden_or_accepted(self) -> None:
        result = classify_returncode(-signal.SIGSEGV, signal.SIGTERM, False)
        self.assertEqual(result["kind"], "SIGSEGV")
        self.assertEqual(result["result"], "FAIL")
        self.assertEqual(result["returncode"], -signal.SIGSEGV)
        self.assertTrue(result["segmentation_fault"])

    def test_managed_term_exit_code_is_not_mislabeled_as_a_signal(self) -> None:
        result = classify_returncode(143, signal.SIGTERM, False)
        self.assertEqual(result["kind"], "EXPECTED_SIGTERM_EXIT_CODE")
        self.assertEqual(result["result"], "PASS")
        self.assertEqual(result["wait_state"], "EXITED")
        self.assertEqual(result["exit_code"], 143)
        self.assertIsNone(result["exit_signal"])
        self.assertFalse(result["normal_exit"])

    def test_other_signal_and_nonzero_exit_fail(self) -> None:
        self.assertEqual(
            classify_returncode(-signal.SIGINT, signal.SIGTERM, False)["result"],
            "FAIL",
        )
        result = classify_returncode(7, signal.SIGTERM, False)
        self.assertEqual(result["kind"], "NONZERO_EXIT")
        self.assertEqual(result["result"], "FAIL")
        self.assertEqual(result["exit_code"], 7)

    def test_forced_kill_fails_even_if_returncode_matches_requested_signal(self) -> None:
        result = classify_returncode(-signal.SIGTERM, signal.SIGTERM, True)
        self.assertEqual(result["kind"], "FORCED_KILL")
        self.assertEqual(result["result"], "FAIL")
        self.assertTrue(result["forced_kill"])


if __name__ == "__main__":
    unittest.main()
