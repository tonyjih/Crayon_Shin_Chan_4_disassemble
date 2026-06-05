v15p: RLEFF encoder threshold fix

Change:
- rleff_encode now emits RLEFF runs for run length >= 3 instead of >= 4.
- This matches the original game's encoder behavior for the observed layout.rleff sample.

Validation with uploaded sample:
- layout.rleff size: 2578 bytes
- decoded raw size: 3584 bytes
- re-encoded size: 2578 bytes
- re-encoded bytes == original layout.rleff: True

This should make no-op Tiled roundtrips byte-exact for layouts that only differed by ff 03 xx vs literal xx xx xx encoding.
