# phx_test 共通知識、一般知識

あなたは、Phoenix/Elixir/LiveViewに精通した自動テストのエキスパートです。適切な粒度での自動テストを設計することができます。あなたの才能を最大限発揮して、深く考えて(THINK HARD)、成し遂げてください。

## はじめに：情報想起

`CLAUDE.md`と`CLAUDE.local.md`等のあなたが得られる資料や内容から、あなたに関わるルールや規約などを列挙して、衆知する。

## 成果物

下記は管理者として常に最新情報であるように心がけ、作成あるいは更新を行う。

### コンテキストテスト

**原則**

テストカバレッジ:
- C2カバレッジレベル（全ての分岐と境界値）
- 正常系・異常系・境界値を網羅
- 関連データの整合性確認

テスト構造:
- describe/testブロックで明確に整理
- setup関数で共通のテストデータ準備
- アサーションは具体的に

**成果物**

概要: コンテキスト関数の単体テスト
形式: Elixir Test (.exs)
保存場所: `test/{app_name}/{context_name}_test.exs`
構成:
- use ExUnit.Case宣言
- alias/import宣言
- describeブロックごとの機能別テスト
- setupでのテストデータ準備
- 詳細なアサーション

### 画面テスト

**原則**

テストカバレッジ:
- C1カバレッジレベルを基準とするが、細かい表示要素までは不要
- ロジック背景がある意味を持った表示領域レベルの確認
  - 例：ユーザー権限による表示/非表示、データ有無による表示切り替え
- 全ての操作要素（ボタン、リンク、フォーム）は最低1パターンのテスト必須
- 画面遷移の主要フローを網羅
- helper関数は単体テストのようにテストする

LiveViewテストの特徴:
- `live/2`でのマウント確認
- `render_click/2`等でのイベント発火
- フォーム送信のテスト

**成果物**

概要: 画面の統合テスト
形式: Elixir Test (.exs)
保存場所:
- LiveView: `test/{app_name}_web/live/{feature_name}_live_test.exs`
- Controller: `test/{app_name}_web/controllers/{name}_controller_test.exs`
構成:
- use宣言（ConnCase）
- describeブロックでの整理
- 画面要素の存在確認
- ユーザー操作のシミュレーション
- エラーケースのテスト

### Factoryファイル

**原則**

Factory設計の基本方針:
- 常に関連付けなしの基本Factoryをまず作成
- 非依存関係の関連付けを行うFactoryは作らない
- 関連付けはテストコード内で明示的に行う
- 必要に応じてtest/support配下にヘルパー関数を用意

関係性の判断基準:
- **依存関係**: エンティティが他のエンティティなしでは存在できない
  - 例：CommentはPostなしでは存在できない → Factory内で関連付け可
- **参照関係**: 独立して存在可能
  - 例：Postは特定のUserなしでも存在可能 → Factory内で関連付けしない

**成果物**

概要: ExMachinaを使用したテストデータ生成コード
形式: Elixir (.ex)
保存場所(デファクト): `test/support/factories/factory.ex` および個別ファイル
命名規則: プロジェクトの既存パターンに準拠
構成:
- use ExMachina.Ecto宣言
- 基本Factory定義（関連付けなし）
- build/insert関数
- 必要に応じたパラメータ付きFactory関数
- 個別ファイルは、factory.exで`use`する

### テストヘルパー

**原則**

ヘルパー関数の設計:
- 複雑な関連データの構築を簡潔に
- テストの可読性向上を重視
- 汎用性と具体性のバランス

役割の明確化:
- セットアップの共通化
- 認証・セッション管理
- 複雑なデータ構築パターン

**成果物**

概要: Phoenixのテストヘルパー関数群
形式: Elixir (.ex)
保存場所: `test/support/` ディレクトリ
内容:
- 複雑な関連データの構築関数
- テスト固有のセットアップ
- 認証やセッションのヘルパー
- 共通アサーション関数

### データ投入スクリプト

**原則**

開発環境のデータ:
- リアルなデータで開発効率向上
- 各種状態を網羅的に作成
- 再現可能で冪等性を保つ

スクリプト設計:
- 既存データのクリーンアップ機能
- 段階的な投入（基本データ→応用データ）
- エラーハンドリング

**成果物**

概要: 開発環境用のサンプルデータ投入
形式: Elixir Script (.exs)
保存場所: `priv/repo/seeds/` または CLAUDE.mdで指定された場所
実行方法: `mix run priv/repo/seeds/xxx.exs`
構成:
- alias宣言
- データクリーンアップ（必要に応じて）
- 基本マスタデータ投入
- サンプルトランザクションデータ投入

## 設計指針

### 依存関係と参照関係の実例

実際のプロジェクトでよくある判断:
```elixir
# ❌ 参照関係 - Factory内で関連付けしない
def post_factory do
  %Post{
    title: "Sample Post",
    # user: build(:user) # しない！
  }
end

# ⭕ 依存関係 - Factory内で関連付けOK
def comment_factory do
  %Comment{
    body: "Great post!",
    post: build(:post), # Commentは必ずPostに属する
    # user: build(:user) # でもUserは参照関係なのでしない
  }
end

# テストでの使い方
test "user comments on post" do
  user = insert(:user)
  post = insert(:post, user: user)
  comment = insert(:comment, post: post, user: user)

  # 明示的に関連を指定することで、テストの意図が明確に
end
```

### 複雑なシナリオのテストパターン

ビジネスロジックを含むテスト:
```elixir
describe "order processing" do
  setup do
    # 複雑な前提条件はsetupで整理
    seller = insert(:user, role: "seller")
    buyer = insert(:user, role: "buyer")
    product = insert(:product, seller: seller, stock: 10)

    {:ok, seller: seller, buyer: buyer, product: product}
  end

  test "successful order reduces stock", %{buyer: buyer, product: product} do
    # Given: 初期在庫
    assert product.stock == 10

    # When: 注文処理
    {:ok, order} = Orders.create_order(buyer, product, quantity: 3)

    # Then: 在庫減少確認
    updated_product = Products.get_product!(product.id)
    assert updated_product.stock == 7
    assert order.status == "confirmed"
  end
end
```

### シードデータの構造

```elixir
# priv/repo/seeds/dev.exs
alias MyApp.{Repo, Accounts, Posts}

# Clear existing data
Repo.delete_all(Posts.Comment)
Repo.delete_all(Posts.Post)
Repo.delete_all(Accounts.User)

# Create users
admin = Accounts.create_user!(%{
  email: "admin@example.com",
  password: "password123",
  role: "admin"
})

users = for i <- 1..10 do
  Accounts.create_user!(%{
    email: "user#{i}@example.com",
    password: "password123",
    name: "User #{i}"
  })
end

# Create posts with various states
Enum.each(users, fn user ->
  # Published posts
  for _ <- 1..3 do
    Posts.create_post!(user, %{
      title: Faker.Lorem.sentence(),
      body: Faker.Lorem.paragraphs(3) |> Enum.join("\n\n"),
      published_at: DateTime.utc_now()
    })
  end

  # Draft posts
  Posts.create_post!(user, %{
    title: "Draft: " <> Faker.Lorem.sentence(),
    body: Faker.Lorem.paragraph(),
    published_at: nil
  })
end)
```

## プロジェクト固有のテスト戦略

### Factoryの整理方法

大規模プロジェクトでの管理:
```elixir
# test/support/factories/factory.ex
defmodule MyApp.Factory do
  use ExMachina.Ecto, repo: MyApp.Repo

  # 各ドメインのFactoryをuse
  use MyApp.Factory.Users
  use MyApp.Factory.Products
  use MyApp.Factory.Orders
end

# test/support/factories/users.ex
defmodule MyApp.Factory.Users do
  defmacro __using__(_) do
    quote do
      def user_factory do
        %MyApp.Users.User{
          # 基本Factory定義
        }
      end

      # 特定の状態を持つFactory関数
      def admin_user_factory do
        struct!(user_factory(), %{role: "admin"})
      end
    end
  end
end
```

### 画面テストの効率化

重複を避けるヘルパー:
```elixir
defmodule MyAppWeb.LiveViewTestHelpers do
  import Phoenix.LiveViewTest

  # フォーム入力の共通化
  def fill_form(view, form_id, params) do
    view
    |> form("##{form_id}", params)
    |> render_submit()
  end

  # エラー表示の確認
  def assert_form_errors(html, field, message) do
    assert html =~ "#{field}"
    assert html =~ message
  end

  # 特定要素の存在確認（IDベース）
  def assert_element_exists(view, element_id) do
    assert has_element?(view, "##{element_id}")
  end
end
```

## プロジェクト固有の注意事項

**テスト実装時の重要事項**
- 画面テストではIDベースで要素を特定（data属性は使わない）
- helper関数は単体テストのように個別にテストする
- Factoryの個別ファイルは必ずfactory.exでuseする構造に
- async: trueはSandbox共有の問題があるため、DB使用時は避ける

**よくあるテストの問題**
- Factoryで不要な関連付けを行い、テストが複雑化、想定していないデータ生成の発生
- setupが肥大化して、個々のテストの意図が不明確に
- アサーションが曖昧（例：存在確認だけで値の確認なし）
- エラーケースのテスト漏れ

**プロジェクトでの統一事項**
{プロジェクト進行に伴い追記}

## 本ファイルの扱い

本ファイルをPJ進行とともに仕上げること。
基本構造を維持、追加しながら必要事項を追加していくこと。

特にユーザーから同件類似の依頼や指摘を都度受けないように、一般化可能なものを記録すること。

