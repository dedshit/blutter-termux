#!/usr/bin/env bash
set -e

IMAGE_NAME="blutter:latest"

if [ $# -lt 2 ]; then
    echo "Usage: $0 <indir> <outdir> [extra args...]"
    echo ""
    echo "Arguments:"
    echo "  indir      Path to APK file or directory containing libapp.so and libflutter.so"
    echo "  outdir     Output directory for analysis results"
    echo "  extra args Additional arguments to pass to blutter (e.g., --no-analysis, --ida-fcn)"
    echo ""
    echo "Examples:"
    echo "  $0 /path/to/app.apk /path/to/output"
    echo "  $0 /path/to/lib/arm64-v8a /path/to/output"
    echo "  $0 /path/to/lib/arm64-v8a /path/to/output --no-analysis --ida-fcn"
    exit 1
fi

INDIR="$(realpath "$1")"
OUTDIR="$(realpath "$2")"
shift 2

if [ ! -e "$INDIR" ]; then
    echo "Error: Input path does not exist: $INDIR"
    exit 1
fi

mkdir -p "$OUTDIR"
chmod 777 "$OUTDIR"

docker run --rm \
    -v "$INDIR:/app/input:ro" \
    -v "$OUTDIR:/app/output" \
    -w /app \
    $IMAGE_NAME \
    /app/input /app/output "$@"
