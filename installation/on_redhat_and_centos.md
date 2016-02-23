# 在 RedHat / CentOS 環境中

在 RedHat 衍生的作業系統下，你可以使用 Crystal 官方的 repository。


## 安裝 repository

首先你必須在 YUM 的組態中加入 repository，你可以使用命令列來進行簡單的安裝:


```
  curl http://dist.crystal-lang.org/rpm/setup.sh | sudo bash
```


這會加入簽名密鑰和 repository 的組態。
你也可以手動執行:

```
rpm --import http://dist.crystal-lang.org/rpm/RPM-GPG-KEY

cat > /etc/yum.repos.d/crystal.repo <<END
[crystal]
name = Crystal
baseurl = http://dist.crystal-lang.org/rpm/
END

```

## 安裝
當設定完 repository 後，你就可以安裝 crystal 了:

```
sudo yum install crystal
```

## 更新

當新版的 Crystal 釋出時你可以使用下列命令來進行更新:

```
sudo yum update crystal
```
