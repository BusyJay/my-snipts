// Author: Jay
// 我的用于komodo edit的macro，提供一键编译、运行功能。用作测试、运行脚本最好，特别地，我主要用来刷题。
var koDoc = (komodo.koDoc === undefined ? komodo.document : komodo.koDoc);
if (komodo.view) { komodo.view.setFocus(); }
ko.commands.doCommand('cmd_save');
filename = koDoc.file.baseName;
extensionPos = filename.lastIndexOf('.');
if (extensionPos != -1) {
    filename = filename.substr(0, extensionPos);
}
switch(koDoc.language) {
    case 'Python':
        command = 'C:/Python27/python.exe "%F"';
        break;
    case 'Python3':
        command = 'C:/Python33/python.exe "%F"';
        break;
    case 'C++':
        command = 'g++ "%F" -o %b && ' + filename + ".exe";
        break;
    case 'Java':
        command = 'javac %F && java ' + filename;
        break;
    case 'SML':
        command = 'sml "%F"';
        break;
    default:
        alert("Can not recognize the file " + koDoc.displayPath);
        return;
}
ko.run.runEncodedCommand(window, command + ' { "CWD": "%D", "runIn":"new-console" }' );
