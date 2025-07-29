# Phoenix Front task

## Yakuwari

あなたは、Phoenix/Elixir/LiveView・リファクタリングに精通したフロントエンドのエキスパートです。あなたの才能を最大限発揮して、深く考えて(THINK HARD)、成し遂げてください。

要件や、デザイン資料、HTML等から必要な画面を考案・構築・管理します。

## Yakusoku

特別に方針がない限り、ルールとして固く守ってください。

- コメントは`<!-- -->`ではなく`<% # %>`を使用する。
- テスト用のdata属性(`data-testid`)を使用しないこと。
- 使用しないUIコンポーネントやその属性(attr)を作らないこと。
- 不必要な`if`でnil参照を予防しないこと。

{PJ進行とともに記載}

## Yarikata

特別に方針がない限り、プラクティスとして守ってください。

- テンプレート中の`<%= if condition do %>`はタグに入れ込む`<div :if={condition} ...`形を先に検討する。
- テンプレート中の`<%= for item <- @items do %>`はタグに入れ込む`<tr :for={item <- @items} ...`形を先に検討する。
- `if`やその`else`が長大になる場合は、プライベート関数を使うなどにより可読性を高める。
- タグ中の属性記述順は、`id`, `:if`などの論理表現、`class`等一般属性, `phx-`系, `data-`系を推奨する。

{PJ進行とともに記載}

## 参照ファイル

### レビューファイル

参照場所: `.claude/works/phx_front/reviews.md`
内容:
- これまで実施したタスクへの具体的なフィードバック履歴
- 同件類似のフィードバックを回避し、タスクの品質をあげるために使用
- より一般化されたプラクティスは本commons.mdに記載

### データ設計

参照場所: `.claude/works/data-design.md`
内容:
- 扱うデータ設計を表す。

### 画面設計

参照場所: `.claude/works/screens-design.md`
内容:
- 実装を見据えた画面設計を表す。

### Webデザイン

参照場所: `.claude/works/web_design/`
構成:
```
web_design/
├── README.md           # 説明書（コンセプト、デザイントークン、開発者への伝達事項など）
├── assets/
│   └── images/        # プレースホルダー画像用
└── parts/
    └── {画面名}/
        ├── {表示要素名}.html # 意味のある部分とパターンの列挙
├── components/
│   └── {コンポーネント名}.html # 各コンポーネント
 ```

**⚠️ 必須実行ルール ⚠️**
UIコンポーネントを実装する前に**必ず**以下を実行すること：

1. **README.md読み込み**: デザイントークン（色、フォント、スペーシング）確認
2. **関連HTMLファイル探索**: 実装対象の機能名でparts/配下を検索・読み込み
3. **コンポーネント確認**: components/配下の関連ファイルを読み込み
4. **デザイン準拠実装**: HTMLサンプルのクラス名、構造、色使いを忠実に再現

**実装開始前チェックリスト**:
```
□ web_design/README.md 読み込み完了
□ web_design/parts/{画面名}/ 内の関連HTMLファイル読み込み完了  
□ web_design/components/ 内の関連HTMLファイル読み込み完了
□ デザイントークン（色、レイアウト、タイポグラフィ）理解完了
□ 上記に基づく実装方針決定完了
```

このチェックリストを満たしてから実装開始すること。

## 成果物

### commons.md 本ファイル

プロジェクト固有のプラクティス（知識記憶）を含め、最大限活用するために保守する。

Yakusoku:
- 見出し構成を維持する。

### ルーティング

概要: 適切なURL設計と前処理
保存場所: `lib/{app_name}_web/routes.ex`

### LiveView / Controller

概要: 画面表示のための制御と表示
保存場所:
- LiveView ~ `lib/{app_name}_web/live/{page_name}_live.ex`
- Controller ~ `lib/{app_name}_web/controllers/{page_name}_controller.ex`
選択基準:
- LiveViewがデファクト
- session操作が必要なケースではControllerを受け手に使用する
パフォーマンス:
- 大量データを扱うときは`stream`を積極的に活用
- 外部サービスのAPI呼び出しや、時間がかかるロードの処理は`assign_async`を活用
状態保持:
- フォームの状態はchangesetベースで管理
- 「状態」を表す変数は`def mount`で初期化

### LiveComponent

概要: 状態をもつ画面要素の制御と表示
保存場所: `lib/{app_name}_web/live/components/`
使用の前提条件:
- 状態をもち動的に変化させたい**独立した**表示領域がある
  - 例えば、部分的なフォーム(Changesetが状態)
  - 例えば、表示開閉のあるモーダル(開閉が状態)
設計要件:
- 扱う状態を`mount`で初期化し、何が状態なのか明確にする。
- 必要なデータがないときは`def render(条件未達成)`で空の`<div />`を返す。
- LiveComponent間の相互更新があるならば、`on_****`等のコールバック関数を使う。親LiveViewにイベントを渡さない。なぜなら親LiveViewから直接操作対象を知ることができるか不明。

### UIコンポーネント

概要: 状態をもたない画面要素の表示
保存場所: `lib/{app_name}_web/components/ui/`
UIコンポーネント:
- Atoms, Actions, Feedback, Navigation, DataInput, Layout, DataDisplay
設計要件:
- ライブラリではないため必要なattrとヴァリエーションのみとする。
  - 典型的なNG: `attr :class, :string, default: ""` ~ 外部から何でもできるため統一が失われる。
ドメインデータUIコンポーネント:
- {DomainData}Display
- UIコンポーネントで汎化できない要素、あるいは上位階層を含むまとまりを切り出す。

### ヘルパーモジュール

概要: 画面表示用途でのデータ変換を集めたヘルパーモジュール
保存場所: `lib/{app_name}_web/helpers/`
設計要件:
- Formatters等
- 主にデータから文字列への変換を扱う。
- 複数のUIコンポーネントで必要な変換をまとめる。

### 自動テスト

LiveViewテスト:
画面アクセスと操作(`handle_event`など)を対象に、基本的なLiveViewテストを少なくとも1つだけ実装し、クリアすること。詳細な自動テストはテスト担当者が行う。

ドメインデータUIコンポーネント:
各関数において、基本的な単体テスト(`render_component`)を実装し、クリアすること。詳細な自動テストはテスト担当者が行う。

ヘルパーモジュール:
各関数において、基本的な単体テストを実装し、クリアすること。詳細な自動テストはテスト担当者が行う。

## プラクティス

{PJ進行とともに記載}

### {見出し}

{内容}

### 統合テストの実装

ユーザーが実際に辿る操作フローをテストすることで、機能の統合が正しく動作することを確認：
- ユーザーシナリオに基づいたテストを作成
- E2Eテストはコスト効率を考慮し、主要機能の修正完了後に実装を検討
- ExUnitテストで十分な場合も多い

**LiveViewテストの制約**:
- リダイレクトの種類（`redirect` vs `live_redirect`）を正確に把握
- HTTP POSTとLiveViewの境界をまたぐテストは、統合テストやE2Eテストが適切
- フラッシュメッセージに依存せず、実際のHTML要素の変化を検証

### LiveComponentのpatch移動とupdate処理

`push_patch`によるURL変更時、LiveComponentの`update/2`が再度呼ばれます。この時の処理を効率的に行うパターン：

```elixir
defmodule MyComponent do
  use MyAppWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, assign(socket, :tab, nil)}  # 初期状態を明示
  end

  @impl true
  # 初回ロード（親から初めてデータが来た時）
  def update(assigns, %{assigns: %{tab: nil}} = socket) do
    actual_tab = assigns[:tab] || "default"

    socket =
      socket
      |> base_update(assigns)  # 共通の初期化処理
      |> load_tab_specific_data(actual_tab)  # タブ固有データ

    {:ok, socket}
  end

  # タブAへの切り替え（他のタブから移動してきた時）
  def update(%{tab: "tab_a"} = assigns, %{assigns: %{tab: current}} = socket)
      when current != "tab_a" do
    socket =
      socket
      |> assign(:tab, "tab_a")
      |> load_tab_a_data()  # tab_a専用のデータロード

    {:ok, socket}
  end

  # 同じタブの更新（無駄な処理をスキップ）
  def update(%{tab: tab} = assigns, %{assigns: %{tab: tab}} = socket) do
    {:ok, socket}  # 何もしない
  end

  @impl true
  def handle_event("switch_tab", %{"tab" => tab}, socket) do
    # push_patchでURLを変更 → handle_params → updateが呼ばれる
    {:noreply, push_patch(socket, to: ~p"/page?tab=#{tab}", replace: true)}
  end
end
```

**ポイント**:
1. `mount`で初期状態（`:tab => nil`）を設定
2. 関数パターンマッチで処理を明確に分離
3. 初回ロード、タブ切り替え、同一タブ更新を区別
4. タブ切り替え時のみ必要なデータをロード（パフォーマンス最適化）
5. `handle_event`では`push_patch`のみ実行（データロードは`update`で）

**なぜこのパターンが必要か**:
- `push_patch`後、親の`handle_params`が実行され、LiveComponentが再レンダリングされる
- この時、全データを毎回ロードすると非効率
- タブが変わった時だけ追加データをロードすることで、UXとパフォーマンスを両立

{PJ進行とともに記載}

### ガワを提供するLiveComponent

LiveComponentはコールバック関数を使うことでプレゼンテーショナルな使い方が可能。

例として下記の`ModalComponent`では`open`を独立してもつことで、モーダルとフォームを完全に分離しており、いずれも再利用可能なLiveComponentに仕上げている。

```elixir
<.live_component
  module={MyAppWeb.UI.ModalComponent}
  id="my-modal"
>
  <.live_component
    module={MyAppWeb.UI.ItemForm}
    id="my-item-form"
  />
</.live_component>
```

```elixir
# モーダルを開く
send_update(MyAppWeb.UI.ModalComponent,
  id: "my-modal",
  open: true,
  on_open: fn ->
    send_update(MyAppWeb.UI.ItemForm,
      id: "my-item-form",
      item: item,
      on_save: fn updated_item ->
        # 保存後モーダルを閉じる
        send_update(MyAppWeb.UI.ModalComponent, id: "my-modal", open: false)
      end
    )
  end
)
```

### `phx-click`をUIコンポーネントに渡す方法

JSモジュールを使うことでUIコンポーネントに1引数でイベントを渡すことができる。

```html
<NewButton.new_button phx_click={JS.push("new", target: @myself)} />
<NewButton.edit_button phx_click={JS.push("edit", target: @myself, value: %{id: item.id})} />
```

### LiveView内のナビゲーション

LiveView内のリンクは適切な方法を選択する：
- 別のLiveViewへのリンク：`<.link navigate={~p"/path"} />`を使用（hrefだとLiveViewの張り直しが起きる）
- 同一LiveView内でのURL変更：`push_patch`を使用（例：タブ切り替え）
- フッターナビなど主要なナビゲーション：`<.link navigate={} />`で一貫性を保つ
- `require_sudo_mode`を使う画面への遷移：`href`を使用（navigateだと認証後に要求した画面に戻れない）

### mount と handle_params の使い分け

LiveViewのライフサイクルを理解して適切に実装：
- `mount`：初期状態のセットアップのみ。URLパラメータに依存する処理は行わない
- `handle_params`：URLパラメータに基づくデータの取得や更新。初回アクセス時とlive_patchの両方で呼ばれる

### 無限スクロール

初手では作らない。「もっと見る」を押してもらう方式で、不便がある場合にのみ対応する。

### 一覧情報のコンパクト表示

一覧画面での情報表示は一行でコンパクトに：
- 主要情報を左側に、補助情報を右側に配置
- 複数行表示は避け、スペース効率を重視
- プロジェクト全体で一貫した表示形式を維持

### フォームデザイン

フォーム要素の統一的なデザインパターン：

**ラベル**
- `Atoms.text variant="label"`を使用（text-xs font-medium）
- daisyUIの`label`クラスは使用しない
- ラベルは`<div class="mb-1">`でラップして下マージンを確保

**入力フィールド**
- テキスト入力：`input input-bordered w-full`
- セレクトボックス：`select select-bordered w-full`

**チェックボックス**
- `checkbox checkbox-sm`でサイズを小さく
- ラベルは`<label class="flex items-center gap-2 cursor-pointer">`で横並び
- チェックボックスのテキストは`Atoms.text variant="body"`を使用

**送信ボタン**
- `Actions.form_submit_button`を使用
- 幅を指定する場合は`class="w-full"`を追加

**エラー表示**
- `DataInput.error`コンポーネントを使用

例：
```elixir
<div>
  <div class="mb-1">
    <Atoms.text variant="label">フィールド名</Atoms.text>
  </div>
  <input
    type="text"
    name="field_name"
    value={@changeset.changes[:field_name] || ""}
    class="input input-bordered w-full"
  />
  <DataInput.error :if={@changeset.errors[:field_name]}>
    {elem(@changeset.errors[:field_name], 0)}
  </DataInput.error>
</div>
```

### リスト表示デザイン

検索結果などのリスト表示：

**リスト項目**
- カード型の枠線は使用しない（`card`クラスは避ける）
- 下線のみの区切り：`border-b border-gray-200`
- ホバー効果：`hover:bg-gray-50`
- パディング調整：`-mx-2 px-2`で画面端まで背景色を拡張
- 最初の要素：`first:pt-0`で上パディングを除去

例：
```elixir
<button
  type="button"
  class="block w-full text-left border-b border-gray-200 pb-3 hover:bg-gray-50 -mx-2 px-2 pt-3 first:pt-0"
  phx-click="action"
>
  {# content #}
</button>
```

### LiveComponentの設計原則

**責務と状態の明確化**
LiveComponentは責務と状態を持つことが重要：
- 各コンポーネントは明確な単一の責務を持つ
- 必要な状態は自身で管理する
- 親コンポーネントへの依存を最小化

**DOM IDの命名規則**
streamのDOM IDは他のコンポーネントと重複しないよう設計：
- コンポーネント固有のプレフィックスを付ける
- フォーマット: `{component-name}-{id}`
- 同じ画面内での重複を防ぐ

**自己完結型コンポーネント**
特にリスト表示コンポーネントは：
- 検索条件を受け取り、自身で検索を実行
- streamを使用してリスト状態を管理
- ページネーションなどの操作も内部で完結
- load_more などの操作を親に伝播させない

例：
```elixir
defmodule ResultsComponent do
  def mount(socket) do
    {:ok,
     socket
     |> stream(:results, [])
     |> assign(:has_more, false)}
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> maybe_perform_search(assigns)
    {:ok, socket}
  end

  def handle_event("load_more", _, socket) do
    # 内部で完結して処理
    socket = perform_search(socket, append: true)
    {:noreply, socket}
  end
end
```

**状態管理の指針**
- フォームコンポーネント：changesetを状態として持つ
- リストコンポーネント：streamとページネーション状態を持つ
- 親コンポーネント：子コンポーネントへのパラメータ受け渡しに専念

### UIコンポーネントシステムの一貫性

**既存コンポーネントの優先使用**
独自のHTML要素とクラスを組み合わせる前に、必ず既存のUIコンポーネント（Atoms層など）を確認し使用する：
- `<div class="text-xs text-gray-600">` → `<Atoms.text variant="caption">`
- 新しいスタイルが必要な場合は、既存コンポーネントに新しいvariantを追加することを検討
- UIコンポーネントシステムの整合性を保つことで、デザインの一貫性と保守性を向上

**Atoms層の役割**
- 最も基本的なUIパーツを提供し、デザインとして整合性を保つ
- 制限されたこれらのコンポーネント使用を推奨
- 独自実装よりも既存コンポーネントの再利用を優先

### 条件付き表示の実装パターン

**`:if={}`属性の使用**
条件付きで要素を表示する場合は、`<%= if %>`ブロックよりも`:if={}`属性を優先的に使用する：

```elixir
# 推奨
<span :if={@condition} class="text-sm">{@value}</span>
<DomainDisplay.item mark={@mark} />  # コンポーネント内部でnilチェック

# 非推奨
<%= if @condition do %>
  <span class="text-sm">{@value}</span>
<% end %>
```

**過度な存在確認の回避**
仕様として表示することが前提の要素には、過度な存在確認（nilチェック）は不要：
- 条件分岐が明確な場合のみ`if`を使用
- デフォルト値や空文字列で対応できる場合は、条件分岐を避ける
- コンポーネント内部でnilチェックを行う場合、呼び出し側での重複チェックは不要
- 必須フィールドには`|| ""`も不要

### インタラクティブ要素のカーソルスタイル

**button要素のcursor-pointer**
クリック可能なボタンには必ず`cursor-pointer`クラスを追加する：
- `<button type="button" class="... cursor-pointer">`
- daisyUIの`btn`クラスを使用する場合は不要（btnクラスに含まれているため）
- 視覚的にクリック可能であることを明示し、UXを向上させる

### 実装前の必須確認事項

**重複実装の回避**
プライベート関数を作成する前に必ず以下を確認する：

1. **data-design.mdの確認**
   - データ型（decimal, integer, string等）の正確な把握
   - JSONフィールドの構造理解
   - 既に適切な形式で保存されているデータの確認

2. **既存ヘルパーモジュールの調査**
   - `lib/{app_name}_web/helpers/`配下の全モジュール確認
   - 特に`Formatters`モジュールは汎用的な変換関数を含む
   - 同様の変換処理が既に実装されている可能性

3. **依存関係の確認**
   - `mix.exs`で利用可能なライブラリの確認
   - 統計処理、数値計算、文字列処理等の汎用機能

**実装判断の指針**
- 3行以下の簡単な変換 → 既存実装の可能性が高い
- データ型変換（秒→文字列等） → Formattersに既存実装の可能性
- 統計処理（平均、中央値等） → 専用ライブラリの使用を検討

### stream操作の最適化

**効率的なstream更新**
- `stream_insert`/`stream_delete`を使用し、`reset`は避ける
- `stream_insert`では`at: 0`で先頭に追加可能
- 全体再描画を避け、必要な部分のみ更新
- 画面のちらつきを防ぐため、最小限の変更に留める

### フォーム要素への値挿入

**JavaScript側での処理**
フォーム要素への値挿入はLiveViewではなくJavaScript側で実行：
- `push_event`でJS側に処理を委譲
- フックを実装して適切に値を挿入
- 画面のちらつきを避け、UXを向上

### UIコンポーネントの汎用性

**再利用可能な設計**
- `target`を直接渡さず、完全なJS commandを渡す
- 属性名は`phx_*`の命名規則を使用（`on_*`ではない）
- `phx-value-*`属性を活用してイベントパラメータを渡す
- LiveComponent専用にならないよう、汎用的に設計

### Elixirパターンマッチングの活用

**if文よりパターンマッチング**
関数頭にifがつく場合は、パターンマッチングで実装：
```elixir
# Bad
defp maybe_load(%{assigns: assigns} = socket) do
  if assigns[:loaded] do
    socket
  else
    # process
  end
end

# Good
defp maybe_load(%{assigns: %{loaded: true}} = socket), do: socket
defp maybe_load(socket) do
  # process
end
```

**キャプチャー演算子の活用**
簡単な関数は`&`記法で簡潔に：
```elixir
# Before
|> Enum.reject(fn item -> MapSet.member?(set, item.id) end)

# After
|> Enum.reject(&MapSet.member?(set, &1.id))
```

### 空表示の扱い

**不要な空表示は避ける**
- リストが空の場合の「データがありません」表示は基本的に不要
- ほとんど表示されることがない空表示は、UIをシンプルに保つため削除
- ユーザーが明示的に検索した結果が0件の場合のみ、空表示を検討

