@echo off
::This file was created automatically by CrossIDE to compile with C51.
C:
cd "\Users\yello\Desktop\UBC\Year 2 (2017)\ELEC 291\project2\nunchuck\"
"C:\CrossIDE\Call51\Bin\c51.exe" --use-stdout  "C:\Users\yello\Desktop\UBC\Year 2 (2017)\ELEC 291\project2\nunchuck\EFM8_I2C_Nunchuck.c"
if not exist hex2mif.exe goto done
if exist EFM8_I2C_Nunchuck.ihx hex2mif EFM8_I2C_Nunchuck.ihx
if exist EFM8_I2C_Nunchuck.hex hex2mif EFM8_I2C_Nunchuck.hex
:done
echo done
echo Crosside_Action Set_Hex_File C:\Users\yello\Desktop\UBC\Year 2 (2017)\ELEC 291\project2\nunchuck\EFM8_I2C_Nunchuck.hex
