# 在 Debian / Ubuntu 環境中安裝

在 Debian 衍生的發行版下，你可以使用 Crystal 官方的軟體源。

## 設定軟體源

首先，你必須在 APT 的設定中加入軟體源，你可以使用下列指令來進行設定：

```
  curl http://dist.crystal-lang.org/apt/setup.sh | sudo bash
  
```

That will add the signing key and the repository configuration. If you prefer to do it manually, execute the following commands as *root*:

```
apt-key adv --keyserver keys.gnupg.net --recv-keys 09617FD37CC06B54
echo "deb http://dist.crystal-lang.org/apt crystal main" > /etc/apt/sources.list.d/crystal.list
apt-get update
```

## 安裝

當設定完軟體源後，你就可以安裝 Crystal 了：

```
sudo apt-get install crystal
```

## 更新

當新版的 Crystal 釋出時，你可以使用下列指令來進行更新：

```
sudo apt-get update
sudo apt-get install crystal
```
