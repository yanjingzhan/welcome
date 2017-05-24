globlaAccount = "breonalanhywxuer@hotmail.com";
globlaPassword = "UQpqLi22";


local tsld = loadTSLibrary("aso.tsl") --库加载
if tsld.status == 0 then --验证判断
	dialog("插件加载异常,退出脚本", 0)

	lua_exit();
	return
end
require("ascmd") --需要加载

--如果普通版tsp可以加上该段代码
local tsld = loadTSLibrary("pretender.tsl") --库加载
if tsld.status == 0 then --验证判断
	dialog("插件加载异常", 0)
	return
end
require("TBackups") --需要加载


--字符串分割函数
--传入字符串和分隔符，返回分割后的table
function string.split(str, delimiter)
	if str==nil or str=='' or delimiter==nil then
		return nil
	end

	local result = {}
	for match in (str..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match)
	end
	return result
end

--返回 true/false 账号 密码
function getAccountInfo(url)

	local sz = require("sz")
	local http = require("szocket.http")
	local res, code = http.request(url);

	if code == 200 then
		local tableTemp = string.split(res,",");

		toast(res);
--		toast(tableTemp[13]);
		if #tableTemp > 12 then
			return true,tableTemp[1],tableTemp[2];
		else 
			return false;
		end
	else
		return false;
	end
end

--closeApp("com.apple.Preferences");
--mSleep(1000);
--openURL("prefs:root=CASTLE");

--mSleep(2000);

local x, y = findImageInRegionFuzzy("xample.png",90, 170, 210, 520, 270,0);
if x ~= -1 and y ~= -1 then        
	touchDown(250,240);
	mSleep(30);
	touchUp(250,240);

	mSleep(1000);

	inputStr(globlaAccount);
	mSleep(300);
	inputStr("\n");

	mSleep(300);

	inputStr(globlaPassword);
	mSleep(300);
	inputStr("\n");

end	











