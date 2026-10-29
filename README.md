# dsh-qq-suite

> 把 DSH 接进 QQ 之后长出来的八件事，拆成八个能单独跑、单独测、单独发的仓库。
>
> 这不是「一个大 monolith 切八份」的产物 —— 是**七个真正模块化的库 + 一个旗舰内核**，每个都能 `git clone` 后 `npm test` 通过。

[![repos](https://img.shields.io/badge/repos-8-blue)](#仓库地图) [![license](https://img.shields.io/badge/license-MIT-green)](LICENSE)

---

## 这是什么

2026-10-23 → 10-29 这七天，我在 DSH（DeepSeek Harness）里干了 14,440 次模型调用，烧掉 18.9 亿 token —— 其中 97.35% 是 prompt cache 命中。把账单按**主题**拆开之后，一个事实很清楚：

> 全部消耗都落在同一个工程上：**一半是改它，另一半是它自己在群里聊天。**

于是我把这七天的产出整理成八个仓库。每个仓库对应账单里的一个主题桶，边界按「能不能独立测试」划，不是按文件夹划。

## 仓库地图

| 仓库 | 一句话 | 对应账单主题（占比） | 测试 |
|---|---|---|---|
| [**qq-bridge**](https://github.com/whatxin7/qq-bridge) | QQ ↔ DSH 桥接内核（旗舰） | 她在线聊天 47.3% + 插件安装与桥接 19.0% | 完整套件 |
| [dsh-token-meter](https://github.com/whatxin7/dsh-token-meter) | 把 DSH 会话日志算成 token 账单，含峰谷价 | 用量与成本核算 0.9% | 29 |
| [dsh-qq-access](https://github.com/whatxin7/dsh-qq-access) | 谁能和 agent 说话：白名单、黑名单、好友申请 | 好友 / 白名单 / 权限 6.3% | 20 |
| [dsh-qq-voice](https://github.com/whatxin7/dsh-qq-voice) | 语音库、音量处理、歌本点歌、OneBot 录音段 | 语音 / 唱歌 / 音色 3.2% | 16 |
| [dsh-qq-stickers](https://github.com/whatxin7/dsh-qq-stickers) | 表情库、情绪检索、表情摘要注入 | 表情包 / 斗图 2.4% | 13 |
| [dsh-mcp-safe-tools](https://github.com/whatxin7/dsh-mcp-safe-tools) | 只读搜索/抓取 MCP + SSRF 防护 + 出站脱敏 | 能力扩展 5.6% | 9 |
| [dsh-session-link](https://github.com/whatxin7/dsh-session-link) | 会话路由、跨会话近况、往事检索、关系图 | 群聊私聊行为调优 3.8% | 60 |
| [dsh-persona-kit](https://github.com/whatxin7/dsh-persona-kit) | 人格卡：模式分节、语气附录、预设校验 | 人格 / 角色卡 5.4% | 11 |

合计 **158 个离线测试**，全部不需要网络、不需要 QQ 账号、不需要模型 API。

## 十秒上手

```bash
git clone https://github.com/whatxin7/dsh-token-meter.git   # 不需要任何 key
cd dsh-token-meter && npm test && node bin/token-meter.mjs scan
```

它会扫 `~/.dsh/sessions/**` 并打出你这台机器的真实用量。其余七个同理，README 首屏就是能直接粘的命令。

## 这八件事之间的真实关系

```
                     ┌──────────────┐
    QQ 消息 ───────► │  qq-bridge   │ ───► DSH 会话（一个会话一个上下文）
                     └──────┬───────┘
        ┌──────────────┬────┴────┬──────────────┬─────────────┐
        ▼              ▼         ▼              ▼             ▼
   qq-access      session-link  persona-kit   qq-voice    qq-stickers
   （谁能说话）    （记得住吗）  （像谁在说）  （怎么发声） （怎么接梗）
        │              │         │              │             │
        └──────────────┴────┬────┴──────────────┴─────────────┘
                            ▼
                    mcp-safe-tools（联网与出站的手）
                            │
                            ▼
                     token-meter（这一切花了多少钱）
```

- **准入**决定"这条消息要不要进模型"——最便宜的优化就是这里挡掉的；
- **联通**决定"进来之后记不记得别处发生的事"；
- **人格**决定"说话像不像一个人"；
- **语音/表情**决定"除了文字还有什么动作"；
- **安全工具**决定"能不能上网、上网会不会被内网钓走"；
- **计量**决定"上面这些到底值多少钱"。

## 成本故事（摘要）

| 档位（输入/缓存/输出，元每百万 tokens） | 全量费用 |
|---|---:|
| 0.5 / 0.15 / 2 | ¥310.46 |
| 1 / 0.2 / 4 | ¥436.47 |
| 2 / 0.5 / 8 | ¥1,057.40 |
| 4 / 1 / 16 | ¥2,114.79 |
| 2 / 2 / 8（缓存不打折） | ¥3,824.11 |

详见 [TOKEN-STORY.md](TOKEN-STORY.md)：七日逐日表、Top-10 会话、主题分布、成本集中度，以及**为什么 97% 命中缓存**还不是省钱的终点。

## 文档

- [ARCHITECTURE.md](ARCHITECTURE.md) —— 分层、数据流、每条边界为什么要这么划
- [TOKEN-STORY.md](TOKEN-STORY.md) —— 18.9 亿 token 的账单与结论

## 许可

MIT © whatxin7。各仓库独立授权，LICENSE 就在各自根目录。


