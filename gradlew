#!/usr/bin/env sh
set -eu

APP_HOME=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
CLASSPATH="$APP_HOME/gradle/wrapper/gradle-wrapper.jar"

if command -v java >/dev/null 2>&1; then
  JAVACMD="java"
else
  echo "ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH." >&2
  exit 1
fi

if [ ! -f "$CLASSPATH" ]; then
  GRADLE_VER=$(sed -n 's/.*gradle-\([0-9.]*\)-bin\.zip.*/\1/p' "$APP_HOME/gradle/wrapper/gradle-wrapper.properties" | head -n 1)
  GRADLE_VER="${GRADLE_VER:-8.9}"
  mkdir -p "$APP_HOME/gradle/wrapper"
  TMP_ZIP="/tmp/gradle-${GRADLE_VER}-bin.zip"
  curl -fsSL "https://services.gradle.org/distributions/gradle-${GRADLE_VER}-bin.zip" -o "$TMP_ZIP"
  unzip -oq "$TMP_ZIP" -d /tmp/gradle-dist
  cp "/tmp/gradle-dist/gradle-${GRADLE_VER}/lib/gradle-launcher-"*.jar "$CLASSPATH"
  rm -rf "$TMP_ZIP" /tmp/gradle-dist
fi

exec "$JAVACMD" $GRADLE_OPTS -classpath "$CLASSPATH" org.gradle.wrapper.GradleWrapperMain "$@"
