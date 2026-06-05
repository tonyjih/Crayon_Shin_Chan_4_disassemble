v15q RLEFF original-like long-run split

Changes from v15p:
- Keeps run-length >= 3 RLE encoding.
- Changes long run splitting to avoid leaving a 1- or 2-byte literal tail.
- This matches observed Stage 3 original data where a 256-byte run is encoded as:
    ff fb 31  ff 05 31
  instead of the shorter:
    ff ff 31  31

This affects only RLEFF recompression. Tiled import/export and object icon logic are unchanged from v15p.
