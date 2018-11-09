# 在 Debian／Ubuntu 環境中安裝

在 Debian 衍生的發行版下，我們可以使用 Crystal 官方的軟體源。

## 設定軟體源

首先必須在 APT 的設定中加入軟體源，我們可以使用下列指令來進行設定：

```bash
curl -sSL https://dist.crystal-lang.org/apt/setup.sh | sudo bash
```

這將加入簽章金鑰和軟體源的設定。

當然，我們也可以手動執行下面的指令：

```bash
curl -sL "https://keybase.io/crystal/pgp_keys.asc" | sudo apt-key add -
echo "deb https://dist.crystal-lang.org/apt crystal main" | sudo tee /etc/apt/sources.list.d/crystal.list
sudo apt-get update
```

## 安裝

當設定完軟體源後，我們就可以安裝 Crystal 了：

```bash
sudo apt install crystal
```

下面列出的套件並不是必須的，但建議安裝以啓用在標準庫中的個別功能：

```bash
sudo apt install libssl-dev      # OpenSSL
sudo apt install libxml2-dev     # XML
sudo apt install libyaml-dev     # YAML
sudo apt install libgmp-dev      # 大數相關
sudo apt install libreadline-dev # Readline
```

當你需要建置 Crystal 編譯器的時候，你會需要一些額外的依賴項，請參閱 [Wiki 頁面](https://github.com/crystal-lang/crystal/wiki/All-required-libraries#ubuntu)上的資訊。一般使用時並不需要安裝這些依賴項目。

## 更新

當新版的 Crystal 釋出時，也可以使用下列指令來進行更新：

```bash
sudo apt update
sudo apt install crystal
```
