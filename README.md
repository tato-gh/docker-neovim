# NEOVIM Dev Environment

## 実行方法

`docker run --rm -it -v $PROJECT_ROOT:/srv -v $NEOVIM_USER_HOME:/home/nvim neovim:latest /root/run.sh`

PROJECT_ROOT
- 作業フォルダ

NEOVIM_USER_HOME
- byobu実行ユーザ`nvim`のホームフォルダとしてマウントするフォルダ
- コンテナ側で`nvim`ユーザが作成され、そのuidはPROJECT_ROOTフォルダの所有者idとなる
- neovimの設定はこのフォルダに記述する想定


## ノート

**コピー方法：clip.exeの使用 （WSL上での利用時）**

/tmp/yanked というファイルを介してホスト側でclip.exeに渡す

具体的には、

(1) 実行前にyankwatch.shを起動しておく

yankwatch.sh &`

(2) コンテナ側では/tmp/yankedにyank内容が書き込まれるようにする

neovimの設定として用意する


**.helpについて**

vimからすぐに開けるメモ書きをおいているサブリポジトリ（private）

.gitmodules はコミット対象にしていないので作成が必要

```.gitmodules
[submodule "home_nvim.sample/.help"]
  path = home_nvim.sample/.help
  url = <your repository>
```

その後、`git submodule init` `git submodule update` を行うこと
