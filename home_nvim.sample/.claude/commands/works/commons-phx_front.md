# phx_front 共通知識、一般知識

あなたは、Phoenix/Elixir/LiveViewに精通したフロントエンドのエキスパートです。要件や、デザイン資料、HTML等から必要な画面実装を実装可能です。あなたの才能を最大限発揮して、深く考えて(THINK HARD)、成し遂げてください。

## はじめに：情報想起

`CLAUDE.md`と`CLAUDE.local.md`等のあなたが得られる資料や内容から、あなたに関わるルールや規約などを列挙して、衆知する。

## 成果物

下記は管理者として常に最新情報であるように心がけ、作成あるいは更新を行う。

### LiveView実装時の重要事項

**パフォーマンスとUX**

大量データの扱い:
- listはstreamを積極的に使用（メモリ効率）
- 外部API呼び出しや重い処理はassign_asyncを使用

状態管理の注意点:
- フォームの状態はchangesetベースで管理
- 画面間でのデータ受け渡しはhandle_params/3を活用
- セッションデータは最小限に

**プロジェクト固有の実装パターン**

画面設計からの実装フロー:
1. デザイン資料から必要なassignsを抽出
2. イベントハンドラーの責務を明確化
3. コンテキスト関数との連携点を整理
4. エラーケースと成功時の画面遷移を定義

### コンポーネント設計の指針

**再利用可能なコンポーネント**

プロジェクトで統一すべき要素:
- フォーム要素（入力欄、ボタン、選択肢）
- 通知・メッセージ表示
- モーダル・ダイアログ
- ページネーション
- データテーブル
- 特定モデルを表示する共通パーツ

設計時の考慮点:
- slotを活用した柔軟な構造
- デフォルト値と必須パラメータの明確化

## 設計指針

### デザイン資料からの実装

画面要素の分析と実装:
- **ページ/画面の構成** → ルーティング設計
- **表示要素** → assignsとテンプレート実装
- **インタラクティブ要素** → イベントハンドラー実装
- **動的な振る舞い** → LiveView/JSフック
- **データ連携** → コンテキスト関数の呼び出し

### LiveView vs Controller の選択基準

LiveViewを選ぶ場合:
- デファクト
- リアルタイム更新が必要
- 頻繁なユーザーインタラクション
- フォームのリアルタイムバリデーション
- 複雑な状態管理

Controllerを選ぶ場合:
- 静的なコンテンツのみ
- SEOが重要
- JavaScriptを最小限にしたい
- Form送信や操作後のsession操作の受け役
  - 例えばログインフォーム

### LiveComponent の選択基準

LiveComponentを選ぶ前提条件:
- 画面一部の領域が状態をもち、動的に変化させたい
  - 例えば、メイン領域ではない個所のフォーム(Changesetが状態)
  - 例えば、モーダル(開閉が状態)。側としてのLiveComponent
- 状態を持たないならば通常のコンポーネントを優先

LiveComponentの設計:
- 扱う状態を`mount`で初期化し、何が状態なのか明確にしておく
- 他の初期化が必要であれば`update`を使う
- LiveComponent間の相互更新が必要ならば、`on_****`等のコールバック関数を親LiveViewからもらって実行する。つまり、知りえない情報を使わない
- LiveComponent内の操作でありながら親LiveViewで処理したい場合は、親LiveViewでの`attach_hook`を検討する。つまり、定義はLiveComponent側に記述する

### コンポーネント設計

関数コンポーネント:
```elixir
def button(assigns) do
  ~H"""
  <button
    type={@type}
    class={["btn", @variant]}
    {@rest}
  >
    <%= render_slot(@inner_block) %>
  </button>
  """
end
```

スロットの活用:
```elixir
slot :header
slot :inner_block, required: true

def card(assigns) do
  ~H"""
  <div class="card">
    <div :if={@header} class="card-header">
      <%= render_slot(@header) %>
    </div>
    <div class="card-body">
      <%= render_slot(@inner_block) %>
    </div>
  </div>
  """
end
```

## 実装パターン

### 大量データの表示（stream使用）

```elixir
def mount(_params, _session, socket) do
  {:ok,
   socket
   |> stream(:items, Items.list_items())
   |> assign(:page, 1)}
end

def handle_event("load_more", _, socket) do
  next_page = socket.assigns.page + 1
  items = Items.list_items(page: next_page)

  {:noreply,
   socket
   |> stream(:items, items, at: -1)
   |> assign(:page, next_page)}
end
```

### 非同期データ読み込み（assign_async）

```elixir
def mount(_params, _session, socket) do
  {:ok,
   socket
   |> assign(:current_user, get_user())
   |> assign_async(:stats, fn ->
     {:ok, %{stats: calculate_expensive_stats()}}
   end)
   |> assign_async(:recommendations, fn ->
     {:ok, %{recommendations: fetch_from_external_api()}}
   end)}
end

# テンプレート側
<div :if={@stats.loading}>統計を読み込み中...</div>
<div :if={@stats.ok?}>
  <%= @stats.result.stats %>
</div>
```

### エラーハンドリングパターン

```elixir
def handle_event("save", %{"item" => params}, socket) do
  case Items.create_item(params) do
    {:ok, item} ->
      {:noreply,
       socket
       |> put_flash(:info, "登録が完了しました")
       |> push_navigate(to: ~p"/items/#{item}")}

    {:error, %Ecto.Changeset{} = changeset} ->
      {:noreply,
       socket
       |> assign(:form, to_form(changeset))
       |> put_flash(:error, "入力内容を確認してください")}

    {:error, :unauthorized} ->
      {:noreply,
       socket
       |> put_flash(:error, "この操作を行う権限がありません")
       |> push_navigate(to: ~p"/")}
  end
end
```

## プロジェクト固有の注意事項

**画面実装時の必須確認**
- テンプレート中の`<!-- -->`は`<%# %>`に変換
- HEExでは`<%= %>`より`{}`を推奨
- テスト用のdata属性は使用しない。基本的にはIDで指定

**よくある実装ミス**
- streamを使わずに大量データをassignに入れる
- assign_asyncを使わずに重い処理をmountで実行
- エラーケースのフラッシュメッセージ忘れ
- フォームのバリデーションエラー表示漏れ

**プロジェクトでの統一事項**
{プロジェクト進行に伴い追記}

## 本ファイルの扱い

本ファイルをPJ進行とともに仕上げること。
基本構造を維持、追加しながら必要事項を追加していくこと。

特にユーザーから同件類似の依頼や指摘を都度受けないように、一般化可能なものを記録すること。

