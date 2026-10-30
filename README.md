# Kochirib olish

```cmd
set PROJECT=mexatron_modul_va_robotlarni_modellashtirish
git clone https://github.com/axmud/mexatron_modul_va_robotlarni_modellashtirish.git %PROJECT%
winget install typst -v 0.14.2
cd %PROJECT%
for %f in (*.typ) do typst compile "%f"
```
