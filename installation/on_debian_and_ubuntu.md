# 在 Debian / Ubuntu 環境中

在 Debian 衍生的作業系統下，你可以使用 Crystal 官方的 repository。

## 安裝 repository

首先你必須在 APT 的組態中加入 repository，你可以使用命令列來進行簡單的安裝:


```
  curl http://dist.crystal-lang.org/apt/setup.sh | sudo bash
  
```

這會加入簽名密鑰和 repository 的組態。
你也可以手動執行:

```
apt-key adv --keyserver keys.gnupg.net --recv-keys 09617FD37CC06B54
echo "deb http://dist.crystal-lang.org/apt crystal main" > /etc/apt/sources.list.d/crystal.list
```

## 安裝

當設定完 repository 後，你就可以安裝 crystal 了:

```
sudo apt-get install crystal
```

## 更新

當新版的 Crystal 釋出時你可以使用下列命令來進行更新:

```
sudo apt-get update
sudo apt-get install crystal
```
