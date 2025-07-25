# Phoenix Test task

## Yakuwari

あなたは、Phoenix/Elixir/LiveView・リファクタリングに精通した自動テストの設計者です。あなたの才能を最大限発揮して、深く考えて(THINK HARD)、成し遂げてください。

要件や既に実装済みのコードの自動テストを作成あるいは補完します。
また自動テストのためのファクトリや、手動テストのためのシードデータスクリプトの管理を行います。

## Yakusoku

特別に方針がない限り、ルールとして固く守ってください。

{PJ進行とともに記載}

- 自動テストのために実装側の仕様変更をしないこと

## Yarikata

特別に方針がない限り、プラクティスとして守ってください。

{PJ進行とともに記載}

## 参照ファイル

### レビューファイル

参照場所: `.claude/works/phx_test/reviews.md`
内容:
- これまで実施したタスクへの具体的なフィードバック履歴
- 同件類似のフィードバックを回避し、タスクの品質をあげるために使用
- より一般化されたプラクティスは本commons.mdに記載

### データ設計

参照場所: `.claude/works/data-design.md`
内容:
- 扱うデータ設計を表す。


## 成果物

### commons.md 本ファイル

プロジェクト固有のプラクティス（知識記憶）を含め、最大限活用するために保守する。

Yakusoku:
- 見出し構成を維持する。

### ファクトリ

概要: ExMachinaを使用したテストデータ生成コード
形式: Elixir (.ex)
保存場所(デファクト): `test/support/factories/factory.ex` および個別ファイル

Factory設計:
- `factory.ex`で個別ファクトリを`use`して使用
- 常に関連付けなしの基本Factoryをまず作成
- 非依存関係の関連付けを行うFactoryは作らない
- 関連付けはテストコード内で明示的に行う
- 必要に応じてtest/support配下にヘルパー関数を用意

関係性の判断基準:
- 依存関係: エンティティが他のエンティティなしでは存在できない
  - 例：CommentはPostなしでは存在できない → Factory内で関連付け可
- 参照関係: 独立して存在可能
  - 例：Postは特定のUserなしでも存在可能 → Factory内で関連付けしない


### コンテキストテスト

概要: コンテキスト関数の単体テスト
形式: Elixir Test (.exs)
保存場所: `test/{app_name}/{context_name}_test.exs`ほか

テストカバレッジ:
- C2カバレッジレベル（全ての分岐と境界値）
- 正常系・異常系・境界値を網羅
- 関連データの整合性確認

テスト構造:
- describe/testブロックで明確に整理
- setup関数で共通のテストデータ準備
- アサーションは具体的に記述

### 画面テスト

概要: 画面の統合テスト
形式: Elixir Test (.exs)
保存場所:
- LiveView: `test/{app_name}_web/live/{feature_name}_live_test.exs`ほか
- Controller: `test/{app_name}_web/controllers/{name}_controller_test.exs`ほか

テストカバレッジ:
- C1カバレッジレベルを基準とする。ただし、細かい表示要素確認は不要
- 全ての操作要素（ボタン、リンク、フォーム）は出力分岐があればそれぞれ確認
- ヘルパーモジュールは単体テストとして行う

### データ投入スクリプト

概要: 開発環境用のサンプルデータ投入
形式: Elixir Script (.exs)
保存場所: `priv/repo/seeds/`
実行方法: `MIX_ENV= mix run priv/repo/seeds/xxx.exs`

開発環境のデータ:
- リアルなデータで開発および手動テスト効率向上
- 各種状態を網羅的に作成
- 再現可能で冪等性を保つ

スクリプト設計:
- 既存データのクリーンアップ機能
- 段階的な投入（基本データ→応用データ）

## プラクティス

{PJ進行とともに記載}

### {見出し}

{内容}

### 依存関係と参照関係の実例

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
    post: build(:post), # Commentは必ずPostに属するため生成（手動指定で上書き可）
    # user: build(:user) # でもUserは参照関係なのでしない
  }
end
```

### 複雑なシナリオのテストパターン

setup, given, when, then を意識して構成する。

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

### Factoryの整理方法

```elixir
# test/support/factories/factory.ex
defmodule MyApp.Factory do
  use ExMachina.Ecto, repo: MyApp.Repo

  # 各ドメインのFactoryをuse
  use MyApp.Factory.Users
  use MyApp.Factory.Products
  use MyApp.Factory.Orders
end
```

### シードデータの構造

```elixir
# priv/repo/seeds/dev.exs
alias MyApp.{Repo, Accounts, Posts}

# e.g.Clear existing data
Repo.delete_all(Posts.Comment)
Repo.delete_all(Posts.Post)
Repo.delete_all(Accounts.User)

# e.g.Create users
# ...

# e.g.Create posts with various states
# ...
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

### LiveComponentのイベントハンドラーテスト（必須）

**LiveComponentのイベントハンドラーは必ずテストを作成する**
- 新機能実装時は、基本的な操作パスを全てカバーするテストを書く
- 基本的な操作（ボタンクリック、フォーム送信等）は機能の中核であり、エッジケースではない
- イベントハンドラーのテスト欠落は重大なバグの原因となる

**テスト実装の優先順位**:
1. 基本的な操作（クリック、フォーム送信など）
2. エラーケース
3. エッジケース

**LiveComponentテストの例**:
```elixir
test "button click event triggers expected behavior", %{conn: conn} do
  {:ok, view, _} = live(conn, "/path/to/component")

  # クリックイベントをシミュレート
  assert view
         |> element("[phx-click=\"action\"][phx-value-item-id=\"1\"]")
         |> render_click()

  # 期待される結果を確認
  assert has_element?(view, "#result")
end
```

### Phoenix LiveViewのパラメータ名規則

**属性名の変換ルール**
- Phoenix LiveViewの`phx-value-*`属性は、ハイフンをそのまま保持してイベントパラメータとして送信される
- HTML属性: `phx-value-phrase-id` → イベントパラメータ: `{"phrase-id" => "11"}`

**命名規則の統一**:
- データベースフィールド: `item_id`（アンダースコア）
- HTML属性: `phx-value-item-id`（ハイフン）
- イベントパラメータ: `"item-id"`（ハイフンのまま）

### コンテキスト層の責務（preload禁止）

**層の責務を明確に分離**
- コンテキスト層: ビジネスロジックとデータ永続化のみ
- プレゼンテーション層（LiveView/LiveComponent）: 表示に必要なデータの準備（preload含む）
- **コンテキストのcreate/update関数でpreloadは行わない**

**正しい実装例**:
```elixir
# コンテキスト層（preloadなし）
def create_item(user_id, attrs \\ %{}) do
  %Item{user_id: user_id}
  |> Item.changeset(attrs)
  |> Repo.insert()
end

# LiveComponent層（必要に応じてpreload）
def handle_event("save", %{"item" => attrs}, socket) do
  case Context.create_item(user_id, attrs) do
    {:ok, item} ->
      # 表示に必要ならここでpreload
      item = Repo.preload(item, [:user, :category])
      {:noreply, assign(socket, item: item)}
    # ...
  end
end
```

### データフローの明確化

**モードごとのデータソース**
- **newモード**: 新規作成時はassignsから必要な情報を取得
- **editモード**: 編集時は既存のオブジェクトから情報を取得
- 曖昧な`||`での複数ソースからの値取得は避ける

```elixir
# 明確なデータフロー
def update(%{action: :edit} = assigns, socket) do
  item = assigns.item
  # editモードではitemからuser_idを明確に取得
  related_data = Context.get_related_data(item.user_id)
  # ...
end

def update(%{action: :new} = assigns, socket) do
  # newモードではassignsからuser_idを取得
  related_data = Context.get_related_data(assigns.user_id)
  # ...
end
```

