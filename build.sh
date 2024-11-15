xcodebuild clean archive \
-scheme ABC \
-project ABC.xcodeproj \
-configuration Release \
-archivePath ./build/app.xcarchive \
ASSETCATALOG_COMPILER_APPICON_NAME=AppIcon_test \
DOMAIN=https://api-test.abc.com

xcodebuild -exportArchive \
-archivePath ./build/app.xcarchive \
-exportPath ./build \
-exportOptionsPlist ./testExportOptions.plist \
-allowProvisioningUpdates

uKey=""
apiKey=""

curl -F "file=@./build/ABC.ipa" \
-F "uKey=${uKey}" \
-F "_api_key=${apiKey}" \
https://www.pgyer.com/apiv1/app/upload
