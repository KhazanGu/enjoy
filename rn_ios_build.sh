#!/bin/bash
set -e

# ⭐️⭐️⭐️⭐️⭐️ RN项目 iOS 打包脚本 ⭐️⭐️⭐️⭐️⭐️

# 开始计时
SECONDS=0  

############################################## 
# ⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️ 配置区域 ⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️ 
#############################################

# 仓库地址（https / ssh 均可）
GIT_REPO=""

# 仓库本地目录
WORK_DIR="$HOME/Desktop/build/react-native-ios-dev"

# 项目主目录名（仓库克隆后所在文件夹）
APP_DIR="react-native-smallworld"

# 需要打包的分支
GIT_BRANCH="dev"

# iOS 配置
WORKSPACE_NAME="ios/SmallWorld.xcworkspace"
SCHEME_NAME="SmallWorld"
CONFIGURATION="Staging"

# 导出方式（app-store / ad-hoc / enterprise / development）
EXPORT_METHOD="ad-hoc"

# 导出路径
EXPORT_PATH="$WORK_DIR/archive"
EXPORT_PLIST_PATH="$WORK_DIR/archive/ExportOptions.plist"

# Apple Team ID
TEAM_ID=""

# 蒲公英
apiKey=""
uKey=""

# 打包环境
ENV_STRING="测试环境"

#############################################
# 📥📥📥📥📥📥📥📥📥📥 拉取代码 📥📥📥📥📥📥📥📥📥📥
#############################################

echo "🚀 开始打包， 打包期间请 关闭VPN!!! 关闭VPN!!! 关闭VPN!!! 关闭VPN!!! 关闭VPN!!! 关闭VPN!!! 关闭VPN!!! 关闭VPN!!! 关闭VPN!!!"
echo -e "请选择打包环境:\n☑️1.测试环境 \n☑️2.生产环境"
read -p "请输入对应数字 [1-2]: " choice

case "$choice" in
  1)
    WORK_DIR="$HOME/Desktop/build/react-native-ios-dev"
    EXPORT_PATH="$WORK_DIR/archive"
    EXPORT_PLIST_PATH="$WORK_DIR/archive/ExportOptions.plist"
    GIT_BRANCH="dev"
    CONFIGURATION="Staging"
    ENV_STRING="测试环境"
    ;;
  2)
    WORK_DIR="$HOME/Desktop/build/react-native-ios-release"
    EXPORT_PATH="$WORK_DIR/archive"
    EXPORT_PLIST_PATH="$WORK_DIR/archive/ExportOptions.plist"
    GIT_BRANCH="release"
    CONFIGURATION="Release"
    ENV_STRING="生产环境"
    ;;
  *)
    WORK_DIR="$HOME/Desktop/build/react-native-ios-dev"
    EXPORT_PATH="$WORK_DIR/archive"
    EXPORT_PLIST_PATH="$WORK_DIR/archive/ExportOptions.plist"
    GIT_BRANCH="dev"
    CONFIGURATION="Staging"
    ENV_STRING="测试环境"
    ;;
esac

echo "🚀 [1/7] 获取仓库代码..."

if [ -d "$WORK_DIR/$APP_DIR/.git" ]; then
  cd "$WORK_DIR/$APP_DIR"
  echo "📦 仓库已存在，更新代码..."
  git fetch --all
  git stash || true
  git checkout "$GIT_BRANCH"
  git reset --hard "origin/$GIT_BRANCH"
else
  mkdir -p "$WORK_DIR"
  cd "$WORK_DIR"
  echo "📥 克隆仓库..."
  git clone -b "$GIT_BRANCH" "$GIT_REPO"
  cd "$APP_DIR"
fi

echo "✅ 已切换到分支：$(git branch --show-current)"

case "$choice" in
  1)
    sed -i '' 's/runTimeEnv: *RuntimeEnv\.[a-zA-Z0-9_]*/runTimeEnv: RuntimeEnv.staging1/' src/boot/config.ts
    echo "✅ 已配置RN环境runTimeEnv为RuntimeEnv.staging1"
    sed -i '' 's/debug: *[a-zA-Z0-9_]*/debug: true/' src/boot/config.ts
    echo "✅ 配置RN环境debug为true"
    ;;
  2)
    sed -i '' 's/runTimeEnv: *RuntimeEnv\.[a-zA-Z0-9_]*/runTimeEnv: RuntimeEnv.production/' src/boot/config.ts
    echo "✅ 已配置RN环境runTimeEnv为RuntimeEnv.production"
    sed -i '' 's/debug: *[a-zA-Z0-9_]*/debug: false/' src/boot/config.ts
    echo "✅ 已配置RN环境debug为false"
    ;;
  *)
    sed -i '' 's/runTimeEnv: *RuntimeEnv\.[a-zA-Z0-9_]*/runTimeEnv: RuntimeEnv.staging1/' src/boot/config.ts
    echo "✅ 已配置RN环境runTimeEnv为RuntimeEnv.staging1"
    sed -i '' 's/debug: *[a-zA-Z0-9_]*/debug: true/' src/boot/config.ts
    echo "✅ 配置RN环境debug为true"
    ;;
esac

# ############################################
# # ⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️ 安装依赖 ⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️ 
# ############################################

echo "🚀 [2/7] 安装依赖..."
echo "🚀 删除Node依赖..."
rm -rf node_modules
echo "🚀 安装Node依赖..."
npm install
npx react-native setup-ios-permissions
echo "🚀 删除iOS依赖..."
rm -rf ios/Pods
echo "🚀 安装iOS依赖..."
cd ios && pod install && cd ..
echo "✅ 依赖安装完成"

# ############################################
# # 🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧 修复问题 🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧 
# ############################################

echo "🚧 [3.1/7] 给 react-native-xcode.sh 添加执行权限..."
XCODE_SH="node_modules/react-native/scripts/react-native-xcode.sh"

if [ -f "$XCODE_SH" ]; then
  chmod +x "$XCODE_SH"
  echo "✅ 已赋予 react-native-xcode.sh 执行权限"
else
  echo "⚠️ react-native-xcode.sh 文件未找到，跳过"
fi

echo "🚧 [3.2/7] 给 launchPackager.command 添加读写权限..."
LP_C="node_modules/react-native/scripts/launchPackager.command"

if [ -f "$LP_C" ]; then
  chmod 775 "$LP_C"
  echo "✅ 已赋予 launchPackager.command 读写权限"
else
  echo "⚠️ launchPackager.command 文件未找到，跳过"
fi

echo "🚧 [3.3/7] 修复 Yoga.cpp 中的逻辑错误..."

YOGA_FILE="node_modules/react-native/ReactCommon/yoga/yoga/Yoga.cpp"

if grep -q "hadOverflow() |" "$YOGA_FILE"; then
  sed -i '' 's/node->getLayout().hadOverflow() |/node->getLayout().hadOverflow() ||/' "$YOGA_FILE"
  echo "✅ Yoga.cpp 已自动修复"
else
  echo "ℹ️ Yoga.cpp 已是最新，无需修改"
fi

echo "🚧 [3.4/7] 修复 RealReachability sa_family_t 导入问题..."

RR_HEADER="ios/Pods/RealReachability/RealReachability/Ping/PingFoundation.h"
if [ -f "$RR_HEADER" ]; then
  if ! grep -q "_sa_family_t.h" "$RR_HEADER"; then
    sed -i '' '/#include <AssertMacros.h>/a\
#import <sys/_types/_sa_family_t.h>
' "$RR_HEADER"
    echo "✅ 已在 AssertMacros.h 后插入 #import <sys/_types/_sa_family_t.h>"
  else
    echo "ℹ️ PingFoundation.h 已包含 _sa_family_t.h，无需修改"
  fi
else
  echo "⚠️ PingFoundation.h 文件未找到，跳过"
fi

echo "🚧 [3.5/7] 删除Info.plist文件中的CFBundleExecutable"

OL_INFO_PLIST="node_modules/react-native-onelogin/ios/Onelogin.bundle/Info.plist"

if [ -f "$OL_INFO_PLIST" ]; then
  echo "🧹 正在删除 react-native-onelogin 中 CFBundleExecutable..."
  plutil -remove CFBundleExecutable "$OL_INFO_PLIST" || echo "⚠️ 删除 CFBundleExecutable 失败（可能已不存在）"
  echo "✅ CFBundleExecutable 已删除"
else
  echo "⚠️ 未找到 Info.plist 文件：$OL_INFO_PLIST"
fi

RNH_INFO_PLIST="node_modules/react-native-hyphenate/ios/RNHyphenate/FeedbackBundle.bundle/Info.plist"

if [ -f "$RNH_INFO_PLIST" ]; then
  echo "🧹 正在删除 react-native-hyphenate 中 CFBundleExecutable..."
  plutil -remove CFBundleExecutable "$RNH_INFO_PLIST" || echo "⚠️ 删除 CFBundleExecutable 失败（可能已不存在）"
  echo "✅ CFBundleExecutable 已删除"
else
  echo "⚠️ 未找到 Info.plist 文件：$RNH_INFO_PLIST"
fi

RNPHO_INFO_PLIST="node_modules/react-native-sm-photo/ios/Resource/PhotoPluginResources.bundle/Info.plist"

if [ -f "$RNPHO_INFO_PLIST" ]; then
  echo "🧹 正在删除 react-native-sm-photo 中 CFBundleExecutable..."
  plutil -remove CFBundleExecutable "$RNPHO_INFO_PLIST" || echo "⚠️ 删除 CFBundleExecutable 失败（可能已不存在）"
  echo "✅ CFBundleExecutable 已删除"
else
  echo "⚠️ 未找到 Info.plist 文件：$RNPHO_INFO_PLIST"
fi

# ############################################
# # 🧱🧱🧱🧱🧱🧱🧱🧱🧱🧱 开始打包 🧱🧱🧱🧱🧱🧱🧱🧱🧱🧱
# ############################################

echo "🚀 [4/7] 清理旧构建..."
xcodebuild clean \
  -workspace "$WORKSPACE_NAME" \
  -scheme "$SCHEME_NAME" \
  -configuration "$CONFIGURATION"
echo "✅ 清理完成"
rm -rf $EXPORT_PATH
echo "✅ 删除历史文件"

echo "🚀 [5/7] 生成归档 (.xcarchive)..."
echo "🔔 当前归档的配置为 $CONFIGURATION"

ARCHIVE_PATH="$EXPORT_PATH/$SCHEME_NAME.xcarchive"
xcodebuild archive \
  -workspace "$WORKSPACE_NAME" \
  -scheme "$SCHEME_NAME" \
  -configuration "$CONFIGURATION" \
  -archivePath "$ARCHIVE_PATH" \
  -sdk "iphoneos" \
  -allowProvisioningUpdates
echo "✅ 归档完成"

echo "🚀 [6/7] 生成 ExportOptions.plist..."
cat > "$EXPORT_PLIST_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0">
<dict>
  <key>method</key>
  <string>$EXPORT_METHOD</string>
  <key>signingStyle</key>
  <string>automatic</string>
  <key>teamID</key>
  <string>$TEAM_ID</string>
</dict>
</plist>
EOF

echo "🚀 [7/7] 导出 IPA..."
xcodebuild -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportPath "$EXPORT_PATH" \
  -exportOptionsPlist "$EXPORT_PLIST_PATH" \
  -allowProvisioningUpdates
echo "✅ 导出 IPA 成功，IPA 文件位于："
ls -lh "$EXPORT_PATH"

# 结束后输出耗时
duration=$SECONDS
echo "✅ 打包完成，用时 $(($duration / 60)) 分 $(($duration % 60)) 秒"

echo "⏫ 正在上传到蒲公英..."
curl -F "file=@$EXPORT_PATH/小世界RN.ipa" \
-F "uKey=${uKey}" \
-F "_api_key=${apiKey}" \
-F "updateDescription=${ENV_STRING}" \
https://www.pgyer.com/apiv1/app/upload \

echo "✅ 脚本执行结束"

