# サーバー内にserver.pidというファイルが先に存在していた時に、サーバーが再起動できなくなる問題を回避する
set -e
rm -f /app/tmp/pids/server.pid
exec "$@"
