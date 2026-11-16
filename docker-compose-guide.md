# Docker Compose 本地安装

需要 Docker Desktop 和 Docker Compose。以下命令在项目目录的 PowerShell 中运行。

首次启动前，为当前终端设置数据库密码（请替换示例值）：

```powershell
$env:DUJIAOKA_DB_PASSWORD = 'replace-with-a-strong-password'
$env:DUJIAOKA_DB_ROOT_PASSWORD = 'replace-with-another-strong-password'
docker compose up -d --build
```

在浏览器打开 <http://localhost:8080/install>，填写：

| 项目 | 值 |
| --- | --- |
| 数据库地址 | `db` |
| 数据库端口 | `3306` |
| 数据库名 | `dujiaoka` |
| 数据库用户名 | `dujiaoka` |
| 数据库密码 | `DUJIAOKA_DB_PASSWORD` 的值 |
| Redis 地址 | `redis` |
| Redis 端口 | `6379` |
| Redis 密码 | 留空 |
| 网站地址 | `http://localhost:8080` |
| 后台路径 | `/admin` |

安装成功后启动队列，并重启 Web 容器以加载安装配置：

```powershell
docker compose --profile worker up -d
docker compose restart web
docker compose ps
docker compose logs -f worker
```

访问 <http://localhost:8080/admin>，默认管理员账号和密码均为 `admin`，登录后立即修改密码。安装程序会生成应用配置；公开部署前请将容器内 `/app/.env` 的 `APP_DEBUG` 改为 `false`，并配置正式域名、HTTPS 和支付回调地址。

每次在新的 PowerShell 窗口执行 Compose 命令前，都需要重新设置上面的两个密码变量。数据库卷初始化后，更改变量不会更改已有数据库用户密码。

`app_data` 保存应用代码、安装配置、安装锁和上传文件；`db_data` 和 `redis_data` 分别保存数据库和 Redis 数据。应用卷首次创建时由镜像初始化，之后重新构建镜像不会自动更新卷里的代码。升级前请备份并规划代码与数据迁移。不要使用 `docker compose down -v`，除非确定要删除这些数据。

查看日志或停止服务：

```powershell
docker compose logs -f web
docker compose --profile worker down
```
