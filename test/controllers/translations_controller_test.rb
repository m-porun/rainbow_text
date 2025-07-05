require "test_helper"

class TranslationsControllerTest < ActionDispatch::IntegrationTest
  # --- newアクションのテスト ---
  test "should get new" do
    get new_translation_url
    assert_response :success
  end

  # --- createアクションのテスト ---
  test "should create translation" do
    assert_difference('Translation.count') do
      # ここに translations#create アクションに送信するデータ（params）を記述します。
      # 例: translationモデルに content:string がある場合
      post translations_url, params: { translation: { content: "テストコンテンツ" } }
    end
    assert_redirected_to translation_url(Translation.last) # 作成後にshowページへリダイレクトされることを期待
  end

  # --- showアクションのテスト ---
  test "should show translation" do
    # テストデータを作成します。test_fixtures/translations.yml を使用することもできます。
    # 例: @translation = translations(:one) のように fixture をロードするか、
    # Translation.create!(content: "表示テスト") のように直接作成します。
    @translation = Translation.create!(content: "テスト表示コンテンツ") # 仮にモデルにcontentカラムがあると仮定

    get translation_url(@translation)
    assert_response :success
  end
end
