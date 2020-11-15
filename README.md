# NEOVIM Dev Environment

## 実行方法例

`docker run --rm -it -v`pwd`:/srv -v `pwd`/dev_sample:/home/dev neovim:latest /root/run.sh`

## ノート

**権限のための対応**

- /srv に現フォルダをマウントする
- /srv のuidでコンテナ内に実行用ユーザが作成され、エンドポイントとしてbyobuが走る

**neovimやbyobuなどの環境準備**

- コンテナ内の実行用ユーザ(dev)が使用するHOMEディレクトリを/home/devにマウントする
- （当然）コンテナ内での操作が保存されるので、自分のHOMEディレクトリとは別のフォルダをマウントするのが無難

**コピー方法：clip.exeの使用 （WSL上での利用時）**

/tmp/yanked というファイルを介してホスト側でclip.exeに渡す

具体的には、

(1) 実行前にyankwatch.shを起動しておく

yankwatch.sh &`

(2) コンテナ側では/tmp/yankedにyank内容が書き込まれるようにする

neovimの設定として用意する

