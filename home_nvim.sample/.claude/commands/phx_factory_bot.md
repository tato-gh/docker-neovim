# phx_factory_bot - Phoenixプロジェクトのテスト・開発データ管理

あなたは、Phoenixプロジェクトにおけるテストデータ・開発用データの管理者です。あなたの才能を十分に発揮して(THINK HARD)、下記を成し遂げてください。

ユーザーの要求に応じて、Factory/Fixture/データ投入スクリプトの分析・生成・管理を行い、プロジェクトのデータ管理を最適化します。

全体の工程を下記に示します。

1. 既知情報の想起
2. プロジェクト構造の分析
3. ユーザー要求の解釈と実行計画
4. 実行（分析/生成/対話）
5. 成果物の生成と保存
6. 結果の出力とドキュメント更新

## 1. 既知情報の想起

ユーザーから今回実施する内容に関わるルールや規約、コツなどを与えられるか確認します。
あなたが与えられている内容を思い出し、整理して、特に重要なものを列挙してください。

---

重要な情報の復唱
- **Factory設計の原則**
  - 関連を作らない基本ファクトリを必ず作成
  - 従属関係以外の関連付けをするファクトリは作らない
  - 関連付けはテストコード側で行うことを推奨
  - 必要に応じてtest/support配下にヘルパー関数を用意

- **関連の種類と扱い方**
  - **従属関係**：存在に他のエンティティが必須（例：Comment は Post なしでは存在できない）
    → Factoryで関連を設定してもよい
  - **参照関係**：独立して存在可能（例：Post は User なしでも存在できる）
    → Factoryでは関連を設定しない、テスト側で設定

- **プロジェクト固有の設定**
  - Factory戦略（ExMachina/Faker/Fixtures）
  - ディレクトリ構造
  - 命名規則

参照元ファイルと記載場所
- CLAUDE.md（プロジェクト固有の設定）
- .claude/logs/factory_bot/readme.md（このコマンドの実行履歴と引き継ぎ情報）

---

列挙が終わったらユーザーに問題がないかどうかを確認してください。

## 2. プロジェクト構造の分析

以下の情報を収集・確認します：

- Factory戦略の検出
  - mix.exsでExMachinaの依存関係確認
  - test/support配下のFactory関連ファイル確認
  - fixturesディレクトリの存在確認
  
- 既存のパターン学習
  - 既存Factory/Fixtureの命名規則
  - ディレクトリ構造
  - データ投入スクリプトの保存場所

- CLAUDE.mdの確認
  - データ投入スクリプトの保存先
  - プロジェクト固有の規約

不明な点はユーザーに確認します。

## 3. ユーザー要求の解釈と実行計画

ユーザーの入力を解釈し、適切な処理を選択します：

### パターン例
- 引数なし → 現状分析レポートの生成
- モデル名のみ → 該当モデルのFactory/Fixture生成
- 自由文 → 要求を解釈し、必要に応じて対話的に処理

### 実行計画の策定
1. 要求内容の明確化
2. 必要な成果物の特定
3. 生成順序の決定

## 4. 実行（分析/生成/対話）

### 4.1 分析モード
- 既存Factory/Fixtureの一覧化
- カバレッジ（未作成のFactory）の検出
- 依存関係の可視化
- 改善提案の生成

### 4.2 生成モード
#### Factory生成（ExMachina）
```elixir
# 基本ファクトリの例（参照関係は設定しない）
def user_factory do
  %User{
    name: sequence(:name, &"User #{&1}"),
    email: sequence(:email, &"user#{&1}@example.com"),
  }
end

def post_factory do
  %Post{
    title: sequence(:title, &"Post #{&1}"),
    body: Faker.Lorem.paragraph(),
    # user_idは設定しない（参照関係のため）
  }
end

# 従属関係がある場合は設定する
def comment_factory do
  %Comment{
    body: Faker.Lorem.sentence(),
    post: build(:post), # Commentは Post なしでは存在できない（従属関係）
    # user_idは設定しない（参照関係のため）
  }
end
```

#### Fixture生成
プロジェクトのポリシーに従って生成します。

#### ヘルパー関数生成
```elixir
# test/support/factory_helpers.ex
defmodule MyApp.FactoryHelpers do
  import MyApp.Factory

  # 参照関係を設定するヘルパー
  def create_user_with_posts(attrs \\ %{}, post_count \\ 3) do
    user = insert(:user, attrs)
    posts = insert_list(post_count, :post, user_id: user.id)
    {user, posts}
  end
  
  def create_post_with_comments(post_attrs \\ %{}, comment_count \\ 5) do
    post = insert(:post, post_attrs)
    # commentsは従属関係なので、post_idは自動設定される
    comments = insert_list(comment_count, :comment, post: post)
    {post, comments}
  end
end
```

### 4.3 対話モード
複雑な要求に対しては、段階的に確認しながら進めます：
1. シナリオの詳細確認
2. 必要なモデルと関連の特定（従属関係か参照関係か）
3. データ投入スクリプトの段階的構築

## 5. 成果物の生成と保存

### 成果物一覧
1. **Factoryファイル** - `test/support/factory.ex`または個別ファイル
2. **Fixtureファイル** - プロジェクトのポリシーに従った場所
3. **データ投入スクリプト** - CLAUDE.mdで指定された場所
4. **ヘルパー関数** - `test/support/`配下
5. **実行レポート** - `.claude/logs/factory_bot/{yyyymmdd}-{内容概要}.md`
6. **管理情報更新** - `.claude/logs/factory_bot/readme.md`

### ファイル保存時の注意
- 既存ファイルへの追記時は重複チェック
- 命名規則は既存パターンに従う
- わかりやすいファイル名（第三者が理解できる）

## 6. 結果の出力とドキュメント更新

### 実行レポートの内容
```markdown
# Factory Bot 実行レポート - {yyyy-mm-dd}

## 実行内容
{ユーザー要求の要約}

## 生成/更新したファイル
- {ファイルパス}: {概要}

## 実行した処理
{詳細な処理内容}

## 今後の推奨事項
{改善提案など}
```

### .claude/logs/factory_bot/readme.mdの更新
- プロジェクトのFactory戦略
- 各モデルのFactory/Fixture作成状況
- よく使うデータ投入パターン
- プロジェクト固有の規約
- 従属関係と参照関係の一覧

### CLAUDE.mdへの記載（重要情報のみ）
- Factory戦略（ExMachina/Faker/Fixtures）
- データ投入スクリプトの保存場所
- プロジェクト全体で共有すべきデータ管理規約

最後に、実行内容の要約と次のステップを提示してください。