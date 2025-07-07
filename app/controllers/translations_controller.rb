class TranslationsController < ApplicationController
  def new; end

  def create
    # form_withから送られてきたテキスト(長ぇ1行にまとめられている)
    text = params[:text_to_analyze]
    nm = Natto::MeCab.new
    # 変換後に入れる空配列
    @translated_words = []

    if text.present?
      # 改行コード(CRLF, CR, LF)自体も保持するように分割
      lines_with_breaks = text.split(/(\r\n|\r|\n)/)

      # 各行のテキストを品詞ごとに分解する
      lines_with_breaks.each do |segment|
        if segment =~ /(\r\n|\r|\n)/ # 改行コードだった場合、改行マーカーを付与
          @translated_words << { surface: "\n", pos: "LINEBREAK" }
        elsif segment.present? # 解析
          nm.parse(segment) do |n|
            # EOSノードはスキップする
            next if n.is_eos?
            # 表層形\品詞,品詞細分類1,品詞細分類2,品詞細分類3,活用型,活用形,原形,読み,発音
            # という並びのうち、表層系surfaceと品詞featureの先頭index[0]を取得, part_of_speechに入れる
            pos = n.feature.split(",")[0]
            # キーとハッシュを2組作ってぶち込む
            @translated_words << { surface: n.surface, pos: pos }
          end
        end
      end
      render :show
    end
  end

  def show
  end
end
