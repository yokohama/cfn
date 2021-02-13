# How to start
- python3で作業をしてください。
- sampleで入っているtemplate（スタック)は、SPA構成でのfargateインフラを構築します。

## 作成
```
$ git clone https://github.com/yokohama/cfn.git
$ cd cfn
$ python cfn.py -c Hoge yourdomain.com
```

## 削除
```
$ python cfn.py -d Hoge
```

- 各スタック(.sh & .template.yml)のアウトプットパラーメーターが、params.cnfに記載されます。

# TODO
- バージョンダウン実行
- バージョン指定実行
- 実行フォルダを指定できるようにする
