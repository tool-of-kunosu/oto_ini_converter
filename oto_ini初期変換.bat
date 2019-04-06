@echo off
cls

cd %~dp0

for %%f in (%*) do (
	ruby %~n0.rb %%f
)

pause
