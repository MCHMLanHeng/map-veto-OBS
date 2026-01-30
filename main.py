# 【Kingsman_】 ban了de_overpass
# 【Gold bling】 ban了de_dust2
# 【Kingsman_】 pick了de_ancient
# 【Gold bling】 pick了de_inferno
# 【Kingsman_】 pick了de_mirage
# 【Gold bling】 pick了de_train
# 【decider】 pick了de_nuke
import os
import shutil
import re
from typing import final

def safe_copy_file(src_file, dst_path):
    """
    安全文件复制：自动创建目录+避免覆盖同名文件
    :param src_file: 源文件路径
    :param dst_path: 目标路径（目录或文件）
    """
    if not os.path.isfile(src_file):
        print(f"错误：源文件 '{src_file}' 不存在或不是文件")
        return
    
    if os.path.isdir(dst_path):
        dst_dir = dst_path
        dst_filename = os.path.basename(src_file)
        final_dst = os.path.join(dst_dir, dst_filename)
    else:
        dst_dir = os.path.dirname(dst_path)
        dst_filename = os.path.basename(dst_path)
        final_dst = dst_path
    
    os.makedirs(dst_dir, exist_ok=True)
    
    count = 1
    temp_dst = final_dst
    while os.path.exists(temp_dst):
        name, ext = os.path.splitext(dst_filename)
        temp_dst = os.path.join(dst_dir, f"{name}_{count}{ext}")
        count += 1
    
    shutil.copy2(src_file, temp_dst)
    print(f"文件安全复制成功：\n源文件：{src_file}\n目标文件：{temp_dst}")

def extract_match_info(text):
    """
    从字符串中提取比赛信息
    格式示例：【队名】 action了de_mapname
    
    返回: 包含(队名, 动作, 地图名)的元组列表
    """
    pattern = r'【(.*?)】\s*(ban|pick)了(de_\w+)'
    matches = re.findall(pattern, text)
    return [list(match) for match in matches]

try:
    os.makedirs('./mapbp', exist_ok=True)
    os.makedirs('./bp_pic', exist_ok=True)
    os.makedirs('./bp_pic_team', exist_ok=True)
    shutil.rmtree('./bp_pic')
    shutil.rmtree('./bp_pic_team')
    shutil.rmtree('./mapbp')
    os.makedirs('./mapbp', exist_ok=True)
    os.makedirs('./bp_pic', exist_ok=True)
    os.makedirs('./bp_pic_team', exist_ok=True)
finally:
    pass
bp = extract_match_info(input('please input information: '))
index = 1
for i in bp:
    team = i[0]
    action = i[1]
    mapname = i[2]



    safe_copy_file(f'./maps_pic/{mapname}.jpg', f'./bp_pic/map{index}.jpg')
    safe_copy_file(f'./team_icons/{team}.png', f'./bp_pic_team/map{index}.png')
    f = open(f'./mapbp/map{index}.txt','w',encoding='utf-8')
    if team == 'decider':
        f.write('decider')
    else:
        f.write(action)
    f.close()

    index += 1
    
