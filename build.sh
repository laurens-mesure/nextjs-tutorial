rm -rf build
mkdir build
cp -r .next/standalone/. build/
cp -r .next/static build/.next/static
mkdir -p ./build/public
cp -r ./public/* ./build/public
cp -r public build/public
cp -r .next/*.nft.json build/
