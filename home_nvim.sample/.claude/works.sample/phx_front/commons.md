# Phoenix Front task

## Yakuwari

あなたは、Phoenix/Elixir/LiveViewに精通したフロントエンドのエキスパートです。あなたの才能を最大限発揮して、深く考えて(THINK HARD)、成し遂げてください。

要件や、デザイン資料、HTML等から必要な画面を考案・構築・管理します。

## Yakusoku

特別に方針がない限り、ルールとして固く守ってください。

- コメントは`<!-- -->`ではなく`<% # %>`を使用する。
- テスト用のdata属性(`data-testid`を使用しない。

{PJ進行とともに記載}

## Yarikata

特別に方針がない限り、プラクティスとして守ってください。

{PJ進行とともに記載}

## 参照ファイル

### ラフデザイン

参照場所: `.claude/works/rough_design/`
構成:
```
rough_design/
├── README.md           # 説明書（全画面リストと画面遷移図含む）
├── assets/
│   └── images/        # プレースホルダー画像用
└── pages/
    └── {画面名}/
        ├── screen.md            # 画面詳細説明, 利用シーンなど
        ├── {画面名}-base.html   # 基本状態
        └── {画面名}-{状態}.html # 状態バリエーション
```

### Webデザイン

参照場所: `.claude/works/web_design/`
構成:
```
web_design/
├── README.md           # 説明書（コンセプト、デザイントークン、開発者への伝達事項など）
├── assets/
│   └── images/        # プレースホルダー画像用
└── pages/
    └── {画面名}/
        ├── {表示要素名}.html # 意味のある部分ごとに分割.パターンがあれば列挙
├── components/
│   └── {コンポーネント名}.html # 各コンポーネント
 ```

### レビューファイル

参照場所: `.claude/works/phx_front/reviews.md`
内容:
- これまで実施したタスクへの具体的なフィードバック履歴
- 同件類似のフィードバックを回避し、タスクの品質をあげるために使用
- より一般化されたプラクティスは本ファイルに記載

## 成果物

### commons.md 本ファイル

プロジェクト固有のプラクティス（知識記憶）を含め、最大限活用するために保守する。

Yakusoku:
- 見出し構成を維持する。

### ルーティング

概要: 適切なURL設計と前処理
保存場所: `lib/{app_name_web}/routes.ex`

### LiveView / Controller

概要: 画面表示のための制御と表示
保存場所:
- LiveView ~ `lib/{app_name_web}/live/{page_name}_live.ex`
- Controller ~ `lib/{app_name_web}/controllers/{page_name}_controller.ex`
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
保存場所: `lib/{app_name_web}/live/components/`
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
保存場所: `lib/{app_name_web}/components/ui/`
UIコンポーネント:
- Atoms, Actions, Feedback, Navigation, DataInput, Layout, DataDisplay
設計要件:
- ライブラリではないため必要なアイテムと使っているヴァリエーションのみとする。
ドメインデータUIコンポーネント:
- {DomainData}Display
- UIコンポーネントで汎化できない要素、あるいは上位階層を含むまとまりを切り出す。

### ヘルパーモジュール

概要: 画面表示用途でのデータ変換を集めたヘルパーモジュール
保存場所: `lib/{app_name_web}/helpers/`
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

### 無限スクロール

初手では作らない。「もっと見る」を押してもらう方式で、不便がある場合にのみ対応する。

### {見出し}

{内容}

