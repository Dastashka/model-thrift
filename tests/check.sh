#!/usr/bin/env bash
cd "$(dirname "$0")/.." || exit 1
failures=0
check() {
	if [ "$2" = "$3" ]; then
		echo "ok   $1"
	else
		echo "FAIL $1: expected '$3', got '$2'"
		failures=$((failures + 1))
	fi
}

printf '%s' '{"tool_input":{"prompt":"find \"model\": here"}}' | bash hooks/guard.sh 2>/dev/null
check "guard rejects a call without model" "$?" "2"
printf '%s' '{"tool_input":{"prompt":"x","model":"sonnet"}}' | bash hooks/guard.sh 2>/dev/null
check "guard passes a call with model" "$?" "0"

first_line=$(bash hooks/session-start.sh | head -n 1)
check "session start prints the rule" "$first_line" "# Model delegation rule (model-thrift plugin)"

scratch=$(mktemp -d)
session="check-$$"
printf '%s\n' '{"message":{"usage":{"input_tokens":2,"cache_read_input_tokens":250000,"cache_creation_input_tokens":1000}}}' > "$scratch/big.jsonl"
printf '%s\n' '{"message":{"usage":{"input_tokens":2,"cache_read_input_tokens":5000,"cache_creation_input_tokens":0}}}' > "$scratch/small.jsonl"
big="{\"session_id\":\"$session\",\"transcript_path\":\"$scratch/big.jsonl\"}"
hint=$(printf '%s' "$big" | bash hooks/context-size.sh)
check "context hint fires above the threshold" "${hint:0:12}" "model-thrift"
repeat=$(printf '%s' "$big" | bash hooks/context-size.sh)
check "context hint stays silent in the same bucket" "$repeat" ""
small=$(printf '%s' "{\"session_id\":\"$session-small\",\"transcript_path\":\"$scratch/small.jsonl\"}" | bash hooks/context-size.sh)
check "context hint stays silent below the threshold" "$small" ""
rm -rf "$scratch" "${TMPDIR:-/tmp}/model-thrift-$session"

crlf=$(cat hooks/*.sh tests/*.sh | tr -cd '\r' | wc -c)
check "scripts have LF line endings" "$crlf" "0"

changed=$(git diff --name-only origin/main -- rule.md hooks | wc -l)
if [ "$changed" -gt 0 ]; then
	pushed=$(MSYS_NO_PATHCONV=1 git show origin/main:.claude-plugin/plugin.json | grep -o '"version": "[^"]*"')
	local_version=$(grep -o '"version": "[^"]*"' .claude-plugin/plugin.json)
	[ "$pushed" != "$local_version" ]
	check "version bumped for rule or hook changes" "$?" "0"
fi

[ "$failures" -eq 0 ] && echo "all green" || echo "$failures failing"
exit "$failures"
