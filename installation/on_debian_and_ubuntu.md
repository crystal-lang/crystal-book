# 在 Debian／Ubuntu 環境中安裝

在 Debian 衍生的發行版下，我們可以使用 Crystal 官方的軟體源。

## 設定軟體源

首先必須在 APT 的設定中加入軟體源，你可以使用下列指令來進行設定：

```
curl https://dist.crystal-lang.org/apt/setup.sh | sudo bash
```

這將加入簽章金鑰和軟體源的設定。

當然，我們也可以以 *root* 權限手動執行：

```
apt-key adv --keyserver keys.gnupg.net --recv-keys 09617FD37CC06B54
echo "deb https://dist.crystal-lang.org/apt crystal main" > /etc/apt/sources.list.d/crystal.list
apt-get update
```

## 安裝

當設定完軟體源後，我們就可以安裝 Crystal 了：

```
sudo apt-get install crystal
```

Sometimes [you will need](https://github.com/crystal-lang/crystal/issues/4342) to install the package `build-essential` in order to run/build Crystal programs. You can install it with the command:

```
sudo apt-get install build-essential
```


## 更新

當新版的 Crystal 釋出時，也可以使用下列指令來進行更新：

```
sudo apt-get update
sudo apt-get install crystal
```
