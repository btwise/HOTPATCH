#!/bin/sh
#
#
BLUE="\033[1;34m"
#GREEN="\033[1;32m"
RED="\033[1;31m"
OFF="\033[m"
STYLE_UNDERLINED="\e[4m"
#
function _toLowerCase()
{
echo "`echo $1 | tr '[:upper:]' '[:lower:]'`"
}
#
function checkLCD()
{
local index=0
#
gDisplayInf=($(ioreg -lw0 | grep -i "IODisplayEDID" | sed -e "/[^<]*</s///" -e "s/\>//"))
#
echo '              显示器列表             '
echo '------------------------------------'
echo '   序 号   |  VendorID  |  ProductID  '
echo '------------------------------------'
for display in "${gDisplayInf[@]}"
do
let index++
#
# Show monitors.
printf "   第%d台   |    ${display:16:4}    |    ${display:20:4}\n" $index
done
#
# Close the table
#
 echo '------------------------------------'
#
#
LCDcount="${#gDisplayInf[@]}"
#LCDcount=2
printf "显示器数量:$RED${LCDcount}${OFF}个\n";
echo ''
#
# 如果有1显示器
if [[ ${LCDcount} == 1 ]]; then
MainLCDnumber=1
else
# 如果有多个显示器
#
cat << QQQ
------------------------------------
|******* 确认内屏(主屏)序号 *******|
------------------------------------
QQQ
read -p "你的内屏(主屏)是？[1~${LCDcount}]: " logo
case $logo in
[[:digit:]]*)
    if ((${logo} < 1 || ${logo} > ${LCDcount})); then
    delete_tmp
    echo "选择错误，退出......";
    echo "";
    exit 0
    fi
    MainLCDnumber=${logo}
    printf "你选择了$RED${MainLCDnumber}号${OFF}显示器\n";
;;
*)  delete_tmp
    echo "选择错误，退出......";
    echo "";
    exit 0
    ;;
esac
fi
#
}
#
# 生成每个显示器的ID
function make_VP_ID()
{
if [[ ${gMonitor:16:1} == 0 ]]; then
# get rid of the prefix 0
gDisplayVendorID_RAW=${gMonitor:17:3}
else
gDisplayVendorID_RAW=${gMonitor:16:4}
fi
# convert from hex to dec
gDisplayVendorID=$((0x$gDisplayVendorID_RAW))
gDisplayProductID_RAW=${gMonitor:20:4}
#
# Exchange two bytes
#
# Fix an issue that will cause wrong name of DisplayProductID
#
if [[ ${gDisplayProductID_RAW:2:1} == 0 ]]; then
# get rid of the prefix 0
gDisplayProduct_pr=${gDisplayProductID_RAW:3:1}
else
gDisplayProduct_pr=${gDisplayProductID_RAW:2:2}
fi
gDisplayProduct_st=${gDisplayProductID_RAW:0:2}
gDisplayProductID_reverse="${gDisplayProduct_pr}${gDisplayProduct_st}"
gDisplayProductID=$((0x$gDisplayProduct_pr$gDisplayProduct_st))
VendorID=$gDisplayVendorID
ProductID=$gDisplayProductID
Vid=$(echo "obase=16;$VendorID" | bc | tr 'A-Z' 'a-z')
Pid=$(echo "obase=16;$ProductID" | bc | tr 'A-Z' 'a-z')
###
}
#
# 显示logo
function logo()
{
#
cat << EEF

  _    _   _____   _____    _____    _____ 
 | |  | | |_   _| |  __ \  |  __ \  |_   _|
 | |__| |   | |   | |  | | | |__) |   | |  
 |  __  |   | |   | |  | | |  ___/    | |  
 | |  | |  _| |_  | |__| | | |       _| |_ 
 |_|  |_| |_____| |_____/  |_|      |_____|
                                           
============================================
主要内容来自syscl、daliansky、steeeve等，在此感谢！

EEF
}
#
# 初始化文件目录
function init_files()
{
    TEMP=$(dirname $0)
    SystemDir="/System/Library/Displays/Contents/Resources/Overrides"
    iMacBMP=${TEMP}"/icontiff/iMac.tiff"
    AirBMP=${TEMP}"/icontiff/Air.tiff"
    ProBMP=${TEMP}"/icontiff/Pro.tiff"
    #
    BoardID=$(ioreg -p IODeviceTree -d 2 -k board-id | grep board-id | sed -e 's/ *["=<>]//g' -e 's/board-id//')

}
# 删除临时文件
function delete_tmp()
{
    rm -rf $TEMP/tmp
}
# 生成临时文件夹
function create_tmp()
{
    mkdir -p $TEMP/tmp/
}
#
# 生成Icons文件
function icons_files_head()
{
IconsFile=$TEMP/tmp/Icons.plist
cat > "$IconsFile" <<-\CCC
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>board-ids</key>
<dict>
<key>BoardID</key>
<dict>
<key>display-resolution-preview-icon</key>
<string>/System/Library/Displays/Contents/Resources/Overrides/DisplayVendorID-VID0/VID0-PID0.tiff</string>
<key>resolution-preview-x</key>
<integer>XXXX0</integer>
<key>resolution-preview-y</key>
<integer>YYYY0</integer>
<key>resolution-preview-width</key>
<integer>WWWW0</integer>
<key>resolution-preview-height</key>
<integer>HHHH0</integer>
</dict>
</dict>
<key>vendors</key>
<dict>
CCC
sed -i '' "s/BoardID/$BoardID/g" $IconsFile
}
#
function icons_files_cycle()
{
cat >> "$IconsFile" <<-\DDD
<key>VID1</key>
<dict>
<key>products</key>
<dict>
<key>PID1</key>
<dict>
<key>display-icon</key>
<string>com.apple.cinema-display</string>
<key>display-resolution-preview-icon</key>
<string>/System/Library/Displays/Contents/Resources/Overrides/DisplayVendorID-VID1/VID1-PID1.tiff</string>
<key>resolution-preview-x</key>
<integer>XXXX1</integer>
<key>resolution-preview-y</key>
<integer>YYYY1</integer>
<key>resolution-preview-width</key>
<integer>WWWW1</integer>
<key>resolution-preview-height</key>
<integer>HHHH1</integer>
</dict>
</dict>
</dict>
DDD
}
#
function icons_files_end()
{
cat >> "$IconsFile" <<-\FFF
<key>display-icon</key>
<string>public.display</string>
</dict>
</dict>
</plist>
FFF
}
#
function make_icons_system()
{
sed -i '' "s/VID0/$Vid/g" $IconsFile
sed -i '' "s/PID0/$Pid/g" $IconsFile
sed -i '' "s/XXXX0/${RP[0]}/g" $IconsFile
sed -i '' "s/YYYY0/${RP[1]}/g" $IconsFile
sed -i '' "s/WWWW0/${RP[2]}/g" $IconsFile
sed -i '' "s/HHHH0/${RP[3]}/g" $IconsFile
}
function make_icons()
{
sed -i '' "s/VID1/$Vid/g" $IconsFile
sed -i '' "s/PID1/$Pid/g" $IconsFile
sed -i '' "s/XXXX1/${RP[0]}/g" $IconsFile
sed -i '' "s/YYYY1/${RP[1]}/g" $IconsFile
sed -i '' "s/WWWW1/${RP[2]}/g" $IconsFile
sed -i '' "s/HHHH1/${RP[3]}/g" $IconsFile
}
# 图标选择菜单
function menu_icon()
{
#
cat << EOF
(1) iMac
(2) MacBook Air
(3) MacBook Pro
其他：退出
EOF
read -p "输入你的选择[1~3]: " logo
case $logo in

1)  cp -r $iMacBMP $TEMP/tmp/DisplayVendorID-$Vid/$Vid-$Pid.tiff
    icons_files_cycle
    RP=("33" "68" "160" "90")
    make_icons
;;
2)  cp -r $AirBMP $TEMP/tmp/DisplayVendorID-$Vid/$Vid-$Pid.tiff
    icons_files_cycle
    RP=("52" "66" "122" "76")
    make_icons
;;
3)  cp -r $ProBMP $TEMP/tmp/DisplayVendorID-$Vid/$Vid-$Pid.tiff
    icons_files_cycle
    RP=("40" "62" "147" "92")
    make_icons
;;
*)  echo "选择错误，退出......";
    echo "";
    delete_tmp
    exit 0
;;
esac
}
#
# EDID选择菜单
function menu_EDID()
{
#
cat << UUU
(1) 本机EDID
(2) 注入花屏补丁的EDID
(3) 无EDID
其他：退出
UUU
read -p "输入你的选择[1~3]: " logo
case $logo in
#修复花屏的EDID数据
1)  EDID=$gMonitor
    edID=$(echo $EDID)
    EDid=$(printf $edID | xxd -r -p | base64)
    sed -i "" "s:EDid:${EDid}:g" $dpiFile
;;
2)  EDID=$gMonitor
    #修改EDID第21个（十进制）数据为B5（原始数据A5）
    edID=$(echo $EDID | sed 's/../b5/21')
    EDid=$(printf $edID | xxd -r -p | base64)
    sed -i "" "s:EDid:${EDid}:g" $dpiFile
;;
3)  EDID=$gMonitor
    edID=$(echo $EDID | sed 's/../b5/21')
    EDid=$(printf $edID | xxd -r -p | base64)
    sed -i "" "/.*IODisplayEDID/d" $dpiFile
    sed -i "" "/.*EDid/d" $dpiFile
;;
*)  echo "选择错误，退出......";
    echo "";
    delete_tmp
    exit 0
;;
esac
}
#
# 无EDID
function NO_EDID()
{
EDID=$gMonitor
edID=$(echo $EDID | sed 's/../b5/21')
EDid=$(printf $edID | xxd -r -p | base64)
sed -i "" "/.*IODisplayEDID/d" $dpiFile
sed -i "" "/.*EDid/d" $dpiFile
}
#
# 生成hidip文件
function make_hidip_files()
{
mkdir -p $TEMP/tmp/DisplayVendorID-$Vid
dpiFile=$TEMP/tmp/DisplayVendorID-$Vid/DisplayProductID-$Pid
#sudo chmod -R 777 $TEMP/tmp/
#
cat > "$dpiFile" <<-\JJJ
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>DisplayProductID</key>
<integer>PID</integer>
<key>DisplayVendorID</key>
<integer>VID</integer>
<key>IODisplayEDID</key>
<data>EDid</data>
<key>scale-resolutions</key>
<array>
JJJ
}
#
#自定义分辨率
function custom_res()
{
    echo "输入自定义分辨率，用空格隔开，像这样：1344x756 1440x810...完成后回车确认"
    read -p "分辨率:" res
    create_res $res
}
# 创建分辨率配置
# 注入xxx*yyy00
function create_res()
{
for res in $@; do
width=$(echo $res | cut -d x -f 1)
height=$(echo $res | cut -d x -f 2)
hidpi=$(printf '%08x %08x' $(($width*2)) $(($height*2)) | xxd -r -p | base64)
cat << OOO >> $dpiFile
<data>${hidpi:0:11}AAAAB</data>
<data>${hidpi:0:11}AAAABACAAAA==</data>
OOO
done
#
}
#
function create_res_1()
{
for res in $@; do
width=$(echo $res | cut -d x -f 1)
height=$(echo $res | cut -d x -f 2)
hidpi=$(printf '%08x %08x' $(($width*2)) $(($height*2)) | xxd -r -p | base64)
#
cat << OOO >> $dpiFile
<data>${hidpi:0:11}A</data>
OOO
done
}
#
function create_res_2()
{
for res in $@; do
width=$(echo $res | cut -d x -f 1)
height=$(echo $res | cut -d x -f 2)
hidpi=$(printf '%08x %08x' $(($width*2)) $(($height*2)) | xxd -r -p | base64)
#
cat << OOO >> $dpiFile
<data>${hidpi:0:11}AAAABACAAAA==</data>
OOO
done
}
#
function create_res_3()
{
for res in $@; do
width=$(echo $res | cut -d x -f 1)
height=$(echo $res | cut -d x -f 2)
hidpi=$(printf '%08x %08x' $(($width*2)) $(($height*2)) | xxd -r -p | base64)
#
cat << OOO >> $dpiFile
<data>${hidpi:0:11}AAAAB</data>
OOO
done
}
#
function create_res_4()
{
for res in $@; do
width=$(echo $res | cut -d x -f 1)
height=$(echo $res | cut -d x -f 2)
hidpi=$(printf '%08x %08x' $(($width*2)) $(($height*2)) | xxd -r -p | base64)
#
cat << OOO >> $dpiFile
<data>${hidpi:0:11}AAAAJAKAAAA==</data>
OOO
done
}
#
# 分辨率选择菜单
function menu_res()
{
# 
cat << EOF
(1) 1920x1080 1440x810 1366x768
(2) 1080P 显示屏
(3) 2K 显示屏
(4) 自定义分辨率
其他：退出
EOF
read -p "输入你的选择[1~4]: " input
case $input in

1)  make_hidip_files
    create_res_1 1920x1080 1440x810 1366x768
;;
2)  make_hidip_files
    create_res_1 1920x1080 1680x945 1440x810 1280x720 1024x576
;;
3)  make_hidip_files
    create_res_1 2048x1152 1920x1080 1680x945 1440x810 1280x720
    create_res_2 1024x576
    create_res_3 960x540
    create_res_4 2048x1152
;;
4)  make_hidip_files
    custom_res
;;
*)  echo "选择错误，退出......";
    echo "";
    delete_tmp
    exit 0
;;
esac
#
create_res_2 1280x720 960x540 640x360
create_res_3 840x472 720x405 640x360 576x324 512x288 420x234 400x225 320x180
create_res_4 1920x1080 1680x945 1440x810 1280x720 1024x576 960x540 640x360
#
cat >> "$dpiFile" <<-\KKK
</array>
<key>target-default-ppmm</key>
<real>10.0699301</real>
</dict>
</plist>
KKK
sed -i '' "s/VID/$VendorID/g" $dpiFile
sed -i '' "s/PID/$ProductID/g" $dpiFile
}
#
function start()
{
#############
local LCDcount=0
local MainLCDnumber=0
    logo
    init_files
    delete_tmp
    create_tmp
    checkLCD
# 一台显示器
if [[ ${LCDcount} == 1 ]]; then
echo "================"
echo "设置显示器分辨率："
gMonitor=${gDisplayInf[0]}
make_VP_ID
menu_res
#####
#####
echo ''
echo '--------------'
printf "选择显示器图标：\n"
icons_files_head
menu_icon
make_icons_system
icons_files_end
#echo ''
#echo '--------------'
#printf "注入显示器EDID：\n"
#menu_EDID
#
NO_EDID
#
else
# 多台显示器
#############
icons_files_head
local j=0
for((i=0;i <= (LCDcount-1);i++));
do
let j++
echo ''
if [[ ${MainLCDnumber} == ${j} ]]; then
echo '=================================='
printf "设置[$RED${STYLE_UNDERLINED}第${j}台${OFF}]显示器(内屏/主屏)分辨率：\n"
else
echo '======================='
printf "设置[$RED${STYLE_UNDERLINED}第${j}台${OFF}]显示器分辨率：\n"
fi
gMonitor=${gDisplayInf[(i)]}
make_VP_ID
menu_res
#####
#####
##
echo ''
if [[ ${MainLCDnumber} == ${j} ]]; then
echo '--------------------------------'
printf "选择[$RED${STYLE_UNDERLINED}第${j}台${OFF}]显示器(内屏/主屏)图标：\n"
else
echo '---------------------'
printf "选择[$RED${STYLE_UNDERLINED}第${j}台${OFF}]显示器图标：\n"
fi
menu_icon
if [[ ${MainLCDnumber} == ${j} ]]; then
make_icons_system
fi
###
#echo ''
#if [[ ${MainLCDnumber} == ${j} ]]; then
#echo '--------------------------------'
#printf "注入[$RED${STYLE_UNDERLINED}第${j}台${OFF}]显示器(内屏/主屏)EDID：\n"
#else
#echo '---------------------'
#printf "注入[$RED${STYLE_UNDERLINED}第${j}台${OFF}]显示器EDID：\n"
#fi
#menu_EDID
#
NO_EDID
#
done
icons_files_end
fi
#
#
sudo cp -r $TEMP/tmp/* $SystemDir/
    echo "开启成功，重启生效"
    echo ""
delete_tmp
}
#
start
#
# 清除HIDIP(保留)
function clear_hidip()
{
if [[ -d $SystemDir/DisplayVendorID-$Vid ]]; then
sudo rm -rf $SystemDir/DisplayVendorID-$Vid
echo "已删除/System/Library/Displays...DisplayVendorID-$Vid"
else
echo "不存在/System/Library/Displays...DisplayVendorID-$Vid"
fi
#
if [[ -e $SystemDir/Icons.plist ]]; then
sudo rm -rf $SystemDir/Icons.plist
echo "已删除/System/Library/Displays...Icons.plist"
else
echo "不存在/System/Library/Displays...Icons.plist"
fi
echo "";
}
