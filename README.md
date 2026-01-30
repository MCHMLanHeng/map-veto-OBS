# map-veto-OBS
## 开始之前
请确认你是否已安装python
感谢b站@姓面名包君

## 演示视频
https://www.bilibili.com/video/BV1DV6iBDEvK/?vd_source=0868340e7b012dbba70e32e3b2bcfb02

## 安装
在OBS中选择场景集合 选择导入 点击集合路径中的三点 选择文件夹中的```mapbp.json``` 点击导入
再次点击场景集合 选择新的场景
点击工具 点击脚本 点击```+```导入```delay_visiable.lua```
在右侧的Sources和Reverse Source中均填入```map1pic,map1team,map1status,map2pic,map2team,map2status,map3pic,map3team,map3status,map4pic,map4team,map4status,map5pic,map5team,map5status,map6pic,map6team,map6status,map7pic,map7team,map7status```
Delay为延迟时间可以按照喜好调整（单位为ms）
## 使用
本项目根据5e服务器后台制作 若不是5e的服务器参考以下格式
    【team_lyc】 ban了de_overpass
    【team_lyc】 ban了de_dust2
    【team_lyc】 pick了de_ancient
    【team_lyc】 pick了de_inferno
    【team_lyc】 pick了de_mirage
    【team_lyc】 pick了de_train
    【decider】 pick了de_nuke
程序会按照格式自动截取队名、bp情况与地图并保存在相应的文件中
本项目可自定义部分多 但需要注意文件格式与大小 否则将会出现显示问题 具体参考后续部分
要确保你输入的队名可以在```team_icons```中找到同名的文件 否则会报错 地图图片同理
默认图片背景为CS2现役地图 可以替换为瓦的
## 自定义格式
### 地图背景
大小必须为240*900
### 队伍图标
大小必须为100*100 可以有透明背景
背景图可以在OBS设置中更换
