# BabyWars
这是一款2D战棋复(chao)刻(xi)游戏作品，复刻对象是GBA上的《高级战争2：黑洞崛起》。代码采用cocos2d-lua方案进行编写，美术资源则直接扒自原版游戏。
![Screenshot](https://github.com/Babygogogo/BabyWars/raw/master/external/Screenshots/screenshot.PNG)

## 特性简介
本复刻主要侧重于实现在线pvp功能。单机对战AI方面，由于原版游戏就已经做的很好，而且可以轻易地通过pc/手机模拟器来玩到，所以本复刻作品将暂时忽略它。

### 计划中的特性
---
- 基础功能
  - 选关
  - 存/读玩家全局数据
  - 游戏设定
  - 战场功能
    - 单位/地形基本动画（战斗动画暂时忽略）
    - 存/读战场数据
    - 单位移动/攻击/占领/待机/建造/消灭/合流/升级等等
    - 指挥官选择/日常修正/特殊技能
    - 胜负判定
    - 明战/雾战
    - 天气系统
- 在线功能
  - 在线存/读玩家全局数据
  - 创建/进入对局
  - 自定义战场设定
  - 战绩排行榜
  - 聊天
- 其他
  - 使用Tiled进行地图编辑
  - 发布到iOS（越狱），安卓，pc平台
  
### 关于特性的一些想法
---
#### 关于单位行动
  一个单位的一次行动可能包括多个步骤，比如移动+攻击，移动+占领，等等。所有的步骤都由玩家自行选择。  
  在确认以上步骤之前，玩家可以随意修改任意步骤；确定后，单位就按照这些步骤行动，玩家不能半途取消。
  
  这种操作方式可以避免玩家在雾战中试探地图，而且可以方便地把所有会对战局产生影响的计算彻底交由服务器进行（玩家修改步骤的计算可以在本地进行，确认步骤后的计算就交给服务器），避免作弊。
  
#### 关于在线对战
  所有会影响战局的计算都交由服务器进行，客户端只负责把玩家的操作上传，以及呈现服务器的计算结果。  
  换言之，如果用MVC的视角来看待战局，那么M在服务器上，VC在客户端上。
  
  优点：
- 游戏不需要对玩家是否同时在线加以区分  
  玩家建立战局后，不管他们当中是否有人离线，对其余玩家以及服务器都没有实质影响（当然，为避免对战过长，双方可以事前设定多长时间内必须走局）。  
  当该玩家重新上线，则客户端根据当时战局的情况，进行合适的呈现即可。
- 最大限度杜绝作弊  
  服务器只把玩家当前可见的单位和地形信息推送到客户端，从根源上杜绝玩家通过破解数据，获知他所不应知道的信息的可能性。同时，客户端也无法干涉服务器的计算，从而保证对战公平。

缺点：
- 玩家必须有网络才能游玩————也就是说，不存在“离线对战”  
  假设允许玩家在无网络的情况下行动一回合，那么客户端必须首先从服务器上获取战局数据（把战局直接放在客户端上？Are you kidding？）。  
  即使忽略获取数据就必须要求有网络这一问题，在数据下载后，恶意玩家就有可能对战局数据进行破解————也就是说，玩家可能直接看到雾战中本应隐藏的敌方单位。  
  总之，离线对战既不完全离线，也不能保证对局无作弊，因此只能放弃。

## 如何安装
目前游戏仍处于初级阶段，并未单独发布各平台的安装包。  

若您希望试玩：  
请联系作者Email:101599838@qq.com，我会制作一个简单的win32平台可用的压缩包发送给您。

若您希望参与开发（真的会有吗？）：  
1. 把代码仓库拷贝到本地，如E:\Projects\BabyWars
2. 下载cocos2d-x v3.9，并创建一个名字为BabyWars的lua工程到任意目录
3. 把上述lua工程目录里的所有文件拷贝到E:\Projects\BabyWars，不要覆盖同名文件
4. 根据自身平台，打开E:\Projects\BabyWars\frameworks\runtime-src 目录下对应的工程文件并编译运行

## 其他
欢迎留言讨论关于这游戏的任意话题、试玩或参与开发，谢谢！