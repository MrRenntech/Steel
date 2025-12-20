@echo off
cd /d "%~dp0.."
tree /f /a > "Readme\project_tree.txt"
echo Project tree updated in Readme folder.
