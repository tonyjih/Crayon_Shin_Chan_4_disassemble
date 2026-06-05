v15i changes:
- Fix stage4/tutorial object icon export crash caused by invalid normal enemy animation table pointers (e.g. $f8eb).
- Prefer umbrella kid preview animation $0f and keep $0c-$0e as fallbacks.
- Add object animation candidate/fallback resolver so stage1 enemy icons can fall back to other normal stage animation tables when the current-stage preview resolves empty.
- Static pickup/form/platform icons are unchanged from v15h.
