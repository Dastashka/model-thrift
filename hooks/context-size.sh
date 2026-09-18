#!/usr/bin/env bash
threshold=200000
step=100000
input=$(cat)
[[ $input =~ \"transcript_path\":\"([^\"]*)\" ]] || exit 0
transcript=${BASH_REMATCH[1]//\\\\//}
[[ $input =~ \"session_id\":\"([^\"]*)\" ]] || exit 0
session=${BASH_REMATCH[1]}
[ -f "$transcript" ] || exit 0
usage=$(tail -c 4000000 "$transcript" | grep -o '"usage":{[^}]*}' | tail -n 1)
total=0
for key in input_tokens cache_read_input_tokens cache_creation_input_tokens; do
	[[ $usage =~ \"$key\":([0-9]+) ]] && total=$((total + BASH_REMATCH[1]))
done
[ "$total" -ge "$threshold" ] || exit 0
bucket=$((total / step))
marker="${TMPDIR:-/tmp}/model-thrift-$session"
[ -f "$marker" ] && [ "$(<"$marker")" = "$bucket" ] && exit 0
echo "$bucket" > "$marker"
echo "model-thrift: this session's context is about $((total / 1000))k tokens and every turn re-reads all of it. Only once the whole task the user asked for is finished, tell the user in one line and suggest saving what matters to memory and starting a new session. While that task is unfinished, say nothing about it: finishing in this session is cheaper than moving."
