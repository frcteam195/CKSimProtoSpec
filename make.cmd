@echo off
rmdir /S /Q generated
mkdir generated
for %%f in (*.proto) do (
    echo %%~nf
	..\CKSimLibCpp\lib\protobuf\protoc.exe %%~nf.proto --cpp_out=generated
)
echo Generated!