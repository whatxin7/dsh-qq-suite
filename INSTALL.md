# 怎么装

八个仓库**没有一个是 DSH 插件，也没有一个是 skill**。它们是三类东西，装法完全不同：

| 类型 | 仓库 | 装完得到什么 |
|---|---|---|
| **命令行工具**（npm 包 + bin） | token-meter · qq-access · voice · stickers · session-link · persona-kit | 一个可执行命令：`token-meter`、`qq-access`、`voice`、`sticker`、`session-link`、`persona` |
| **MCP server** | mcp-safe-tools | 不是命令，由 MCP 客户端（DSH / Claude Desktop / Cursor）当子进程启动 |
| **文档仓库** | qq-suite（本仓库） | 没有代码，只有文档 |

旗舰 [qq-bridge](https://github.com/Derpyu520/qq-bridge) 是独立的 Node 服务（不是插件），有自己的启动方式。

## 三种装法（命令行工具）

```bash
# 1) 零安装，先试一次（需要 node ≥ 20 + git）
npx github:whatxin7/dsh-token-meter scan

# 2) 装成全局命令（推荐日常用）
npm i -g github:whatxin7/dsh-token-meter
token-meter scan

# 3) 想改代码 / 跑测试
git clone https://github.com/whatxin7/dsh-token-meter.git
cd dsh-token-meter && npm install && npm test
```

六个命令，照抄即可：

```bash
npx github:whatxin7/dsh-token-meter scan
npx github:whatxin7/dsh-qq-access init --out config.json
npx github:whatxin7/dsh-qq-voice doctor
npx github:whatxin7/dsh-qq-stickers faces
npx github:whatxin7/dsh-session-link keys --state state/
npx github:whatxin7/dsh-persona-kit check roles/example-companion.md
```

装全局就是把 `npx github:whatxin7/<repo>` 换成 `npm i -g github:whatxin7/<repo>`，之后直接用命令名。

## ⚠️ 三个包名被占了，别写 `npm i`

npm registry 上这几个名字**是别人的项目**（同领域，容易搞混）：

| 包名 | 现在归谁 | 我们的做法 |
|---|---|---|
| `dsh-token-meter` | 另一个 DSH token 面板 | 走 `github:whatxin7/...` |
| `dsh-qq-access` | Applepinea 的 DSH QQ 通道 | 走 `github:whatxin7/...` |
| `dsh-session-link` | PwnKY 的 dsh:// 深链工具 | 走 `github:whatxin7/...` |

所以 `npm i dsh-token-meter` 装到的是**别人的包**。以后正式发 npm 会带 scope：`@whatxin7/dsh-token-meter`。

## MCP server 怎么用

```bash
git clone https://github.com/whatxin7/dsh-mcp-safe-tools.git
cd dsh-mcp-safe-tools && npm install
```

然后在 MCP 客户端的配置里指向**绝对路径**：

```json
{
  "mcpServers": {
    "web-search-safe": { "command": "node", "args": ["/绝对路径/src/mcp-web-search-safe.js"] },
    "snowluma-host":   { "command": "node", "args": ["/绝对路径/src/mcp-host-server.js"] }
  }
}
```

只想确认它能起：`npx github:whatxin7/dsh-mcp-safe-tools`（stdio 握手成功后 Ctrl+C）。

## 一键拉全部

两个脚本就在本仓库根目录（`install.ps1` / `install.sh`），先拿到它们：

```bash
git clone https://github.com/whatxin7/dsh-qq-suite.git
cd dsh-qq-suite
```

```powershell
# Windows：只 clone，或 clone + 全局安装六个 CLI
powershell -ExecutionPolicy Bypass -File install.ps1
powershell -ExecutionPolicy Bypass -File install.ps1 -Tools -Dir D:\tools
```

```bash
# macOS / Linux
./install.sh
./install.sh --tools --dir ~/tools
```

脚本只做三件事：`git clone` 到 `repos/`（或你指定的目录）、对需要依赖的两个仓库 `npm install`、`-Tools/--tools` 时 `npm i -g`。不写配置、不改 PATH、不装系统服务。

## 版本与更新

- 用 `github:` 装的是**仓库 main 分支的最新提交**，没有语义化版本标签；想锁定就 clone 后用 `git checkout <sha>`。
- 更新：`npm i -g github:whatxin7/<repo>` 重跑一次即可（npm 会重新拉取）。
- 每个仓库都带 CI（3 系统 × Node 20/22/24），绿勾才代表这份代码在干净环境里测试通过。
