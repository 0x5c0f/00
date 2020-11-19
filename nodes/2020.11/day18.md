# 持续集成  
## 什么是`DevOps`  
`DevOps` 是一个框架，是一种理论方法，并不是一套工具，他包括一系列的基本原则和实践。其核心价值着重于**更快速的交付，响应市场的变化。更多的关注业务的改进与提升。**  

# git 
`工作目录`-`暂存区域(git add)`-`本地仓库(git commit)`-`远程仓库(git push)`  

## 初始配置  
```bash
$> git config --global user.name 0x5c0f
$> git config --global user.email mail@0x5c0f.fun
$> cat ~/.gitconfig # 系统层面位于/etc/ 下 ; 项目层面，项目根目录
[user]
	name = 0x5c0f
	email = mail@0x5c0f.fun

$> git config  --list
user.name=0x5c0f
user.email=mail@0x5c0f.fun
```
## 初始项目 
### 基础操作 
```bash
$> mkdir /data/gittest -p && cd /data/gittest 
$> git init 
$> tree -a 
.
└── .git
    ├── branches
    ├── config
    ├── description
    ├── HEAD
    ├── hooks
    ......
    ├── objects     
    │   ├── info
    │   └── pack 
    ...... 

# 移除缓冲区文件 
$> git rm --cached <file>

# 移除本地及缓冲区文件     
$> git rm -f <file>

# 重命名 
$> mv <file> <file>.txt 
$> git rm --cached <file>
$> git add <file>.txt       # git commit -m ""

# 查看修改详情 
$> git diff <file>         

# 查看提交历史 
$> git log 

# 查看提交历史(精简)
$> git log --oneline 

# 撤回修改文件(未add时) 
$> git checkout -- <file>

# 撤回修改文件(未commit时) 
$> git reset HEAD <file>    # git checkout -- <file>

# 撤回修改文件(未push时)
$> git reset --hard <commitid>

# 查看历史操作记录 
# 此命令大体执行在git reset --hard <commitid> 之后，因为执行了git reset --hard <commitid>后，git log将不再看到commitid之后的所有提交记录 
$> git reflog

```

### 分支 
分支创建后，直接增删，各个分支不受影响  

```bash
# 创建分支 
$> git branch test01    # 删除 git branch -d test01
# 查看分支 
$> git branch
* master
  test01

# 切换分支 
$> git checkout test01  # git status    # git log --oneline --decorate  

# 合并分支(比如：合并test01到master中，则当前需要切换到master中执行)
# 当两个分支中，同时修改了一个文件，则会出现合并冲突，此时需要手动处理冲突文件 
$> git merge test01  

```

### 标签 
标签可以作为一个`commitid`的惟一标记，相当于给`commitid`取的别名吧 
```bash
# 给当前commit创建标签
$> git tag v1.0     # git tag -a v1.0   # -a: 打开注释编辑页面 可使用-m "message"替代  
# 针对特定commit打标签
$> git tag v1.0 <commitid>
# 查看所有标签
$> git tag 

# 查看当前标签的详细信息 
$> git show v1.0 

# 删除标签 
$> git tag -d v1.0 

# 重置到某个标签(提交点)
$> git reset --hard v1.0  # or git reset --hard <commit>
```