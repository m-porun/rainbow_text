FROM ruby:3.3.6

# 環境変数の設定
ENV LANG C.UTF-8  # 日本語対応
ENV TZ Asia/Tokyo # タイムゾーンを日本に設定

# 必要なパッケージのインストール
RUN apt-get update -qq && apt-get install -y ca-certificates curl gnupg && \
    # Node.js & Yarn のリポジトリ設定
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    NODE_MAJOR=20 && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /etc/apt/keyrings/yarn.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq && apt-get install -y \
    build-essential \
    nodejs \
    yarn \
    vim \
    mecab \
    libmecab-dev \
    mecab-ipadic-utf8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# mecab-config検索コマンド対策。パスの指定
ENV MECAB_PATH /usr/lib/aarch64-linux-gnu/libmecab.so

# アプリケーションディレクトリの作成
RUN mkdir /myapp
WORKDIR /myapp

# Bundlerのインストール
# GemfileとGemfile.lockを先にコピー
COPY Gemfile* ./
# BundlerとGemを先にインストールすることで、アプリケーションコードの変更時にGemの再インストールを避ける
RUN bundle install

# アプリケーションのコードをコピー
COPY . /myapp

# Fly.ioデプロイでRailsサーバー使わせるよう
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000", "-e", "production"]
