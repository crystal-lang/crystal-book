# 在適用於 Linux 的 Windows 子系統（On Bash on Ubuntu on Windows）上安裝

雖然 Crystal _還沒有_支援 Windows，但我們仍可以利用 Windows 10 上推出的新功能「[適用於 Linux 的 Windows 子系統（搶先版(Beta)）](https://msdn.microsoft.com/zh-tw/commandline/wsl/about)」來嚐鮮看看。

這個功能可以在 Windows 上面建立一個實驗性質的 Bash 環境，接下來的過程會與在 [Debian／Ubuntu](on_debian_and_ubuntu.md) 上的安裝過程類似，但還有一些地方要主意。

別忘了，這個方式充滿了**實驗**性質（他可能很不穩定）。

## 設定軟體源

首先必須在 APT 的設定中加入軟體源，你可以使用下列指令來進行設定：

```
curl -sSL https://dist.crystal-lang.org/apt/setup.sh | sudo bash
```

這將加入簽章金鑰和軟體源的設定。

當然，我們也可以手動執行：

```
sudo apt-key adv --keyserver keys.gnupg.net --recv-keys 09617FD37CC06B54
echo "deb https://dist.crystal-lang.org/apt crystal main" | sudo tee /etc/apt/sources.list.d/crystal.list
sudo apt-get update
```

## 全部所需的函式庫

Crystal 需要一個可用的 C 語言編譯器（`cc`）與一個可用的連結器（`ld`）來編譯 Crystal 程式，你需要用以下的方式來安裝他們：

```
sudo apt-get install clang binutils
```

## 安裝

當設定完軟體源及安裝完所需的函式庫後，我們就可以安裝 Crystal 了：

```
sudo apt-get install crystal
```

## 更新

當新版的 Crystal 釋出時，也可以使用下列指令來進行更新：

```
sudo apt-get update
sudo apt-get install crystal
```
