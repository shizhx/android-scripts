#!/bin/bash
# switch JDK for Ubuntu

PROGRAM_NAME=$(basename "$0")
MIN_MODE=0
MAX_MODE=1

ALTERNATIVE_JAVA=("/usr/local/java/jdk1.8.0_45/bin/java" "/usr/local/java/jdk1.6.0_45/bin/java")
ALTERNATIVE_JAVAC=("/usr/local/java/jdk1.8.0_45/bin/javac" "/usr/local/java/jdk1.6.0_45/bin/javac")
ALTERNATIVE_JAVAWS=("/usr/local/java/jdk1.8.0_45/bin/javaws" "/usr/local/java/jdk1.6.0_45/bin/javaws")
ALTERNATIVE_JAVAH=("/usr/local/java/jdk1.8.0_45/bin/javah" "/usr/local/java/jdk1.6.0_45/bin/javah")
ALTERNATIVE_JAVAP=("/usr/local/java/jdk1.8.0_45/bin/javap" "/usr/local/java/jdk1.6.0_45/bin/javap")
ALTERNATIVE_JAVADOC=("/usr/local/java/jdk1.8.0_45/bin/javadoc" "/usr/local/java/jdk1.6.0_45/bin/javadoc")

mode=-1

if [ -z "$1" ]; then
    echo "Usage: ./$PROGRAM_NAME <mode>" >&2
    echo "  mode:" >&2
    echo "    0 -- Oracle JDK 1.8" >&2
    echo "    1 -- Oracle JDK 1.6" >&2

    exit 1
fi

re='^[0-9]+$'
if ! [[ "$1" =~ $re ]]; then
    echo "Invalid mode: $1" >&2
    exit 1
fi

mode="$1"
if [ $mode -lt $MIN_MODE ] || [ $mode -gt $MAX_MODE ]; then
    echo "Invalid mode: $mode" >&2
    exit 1
fi

if [ "$UID" != "0" ]; then
    echo "MUST run under root user" >&2
    echo "use sudo ./$PROGRAM_NAME" >&2
    exit 1
fi

update-alternatives --set java "${ALTERNATIVE_JAVA[$mode]}"
update-alternatives --set javac "${ALTERNATIVE_JAVAC[$mode]}"
update-alternatives --set javaws "${ALTERNATIVE_JAVAWS[$mode]}"
update-alternatives --set javah "${ALTERNATIVE_JAVAH[$mode]}"
update-alternatives --set javap "${ALTERNATIVE_JAVAP[$mode]}"
update-alternatives --set javadoc "${ALTERNATIVE_JAVADOC[$mode]}"

