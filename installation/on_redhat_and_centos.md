# 在 RedHat／CentOS 環境中安裝

在 RedHat 衍生的發行版下，我們可以使用 Crystal 官方的套件資料庫。

## 設定套件資料庫

首先必須在 YUM 的設定中新增套件資料庫，我們可以使用下列指令來設定：

```
  curl https://dist.crystal-lang.org/rpm/setup.sh | sudo bash
```

這將加入簽章金鑰及套件資料庫的設定。

當然，我們也可以手動執行：

```
rpm --import https://dist.crystal-lang.org/rpm/RPM-GPG-KEY

cat > /etc/yum.repos.d/crystal.repo <<END
[crystal]
name = Crystal
baseurl = https://dist.crystal-lang.org/rpm/
END
```

## 安裝

當設定完套件資料庫後，就可以安裝 Crystal 了：

```
sudo yum install crystal
```

## 更新

當新版的 Crystal 釋出時，也可以使用下列指令來進行更新：

```
sudo yum update crystal
```
