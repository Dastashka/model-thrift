#!/usr/bin/env bash
if grep -Eq '(^|[^\\])"model"[[:space:]]*:'; then
	exit 0
fi
echo 'model-thrift: pass `model` explicitly on every Agent call (sonnet for search/reading, one tier below the session model for execution/review, or the session model alias to keep it there).' >&2
exit 2
