--com.apple.Preferences
--com.apple.AppStore

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

function getAccountInfo(url)

	local sz = require("sz")
	local http = require("szocket.http")
	local res, code = http.request(url);

	if code == 200 then
		local tableTemp = string.split(res,",");

		toast(res);
--		toast(tableTemp[13]);
		if #tableTemp > 12 then
			return true,tableTemp[1],tableTemp[2],tableTemp[3],tableTemp[12];
		else 
			return false;
		end
	else
		return false;
	end
end


function  killVPN()
	for i=0,10,1 do
		flag = getVPNStatus()
		if flag.active then
			setVPNEnable(false);
		else
			return true;
		end
		mSleep(1000);
	end
	return false;
end

function  connectVPN()
	for i=0,10,1 do
		setVPNEnable(true);
		mSleep(3000);

		flag = getVPNStatus()
		toast(flag.status,1)
		if  string.find(flag.status,"已连接") == 1 or string.find(flag.status,"Connected") == 1  then
			return true;
		end
	end
	setVPNEnable(false);
	return false;
end



--如果普通版tsp可以加上该段代码
local tsld = loadTSLibrary("aso.tsl") --库加载
if tsld.status == 0 then --验证判断
	dialog("插件加载异常,退出脚本", 0)

	lua_exit();
	return
end
require("ascmd") --需要加载
--以上代码请在脚本开头先调用验证加载，只需加载一次

local bkvs = ASOVersions()
if bkvs ~= "1.0.9.3" then --自己上传的文件版本号
	delFile(userPath().."/plugin/aso.tsl") --删除老版本
end

--account = "CritesYanki4048@hotmail.com";
--password = "LGbRKr22";

account = "x36t8@ui6.top";
password = "Dd112211";


--AppStore
--[====[

--closeApp("com.apple.AppStore"); 
--mSleep(3000);

r = runApp("com.apple.AppStore");
if r == 0 then
	toast("启动 AppStore 成功",1);

	hasLoginned = false;
	for j=0,2,1 do			
		toast("第" .. j .. "次执行登陆",1);

		appstoreLogout();
		mSleep(2000);
		appstoreLogin(account,password);

		for i=0,10,1 do
			mSleep(2000);
			local status = appstoreStatus() 
			if status == 1 then 
				toast("登录成功",1);
				hasLoginned = true;
				break
			else
				toast(i .. "次登录失败，" .. status,1);
			end
		end

		if hasLoginned then
			break
		end
	end

	if not hasLoginned then
		toast('执行登陆失败！！！',1);
	end
else
	toast("启动 AppStore 失败",1);
end

]====] 

--找字
--[====[
--内容已复制到剪贴板!
local index = addTSOcrDict("空瓶装水解谜.txt")
toast(index);

--local tab = {
--"000401c1fcc0383fb807060fc0e0c1f81c187703831ce070671c0e0de381cd98703bf00e073e01ffe1c03ffc1807038330e070671c0e0ce381c18e703830ee07061dc0e0c1f81c1f9c0383f3007000000e0000000000000000080001c380e330703ef60e3f8fffffc0ffffc00707000060e0001c1c000fffffe7fffffce60e0188c1c000dc380418071fc3fffff87ffffe0fe301c18cf070318f1c0630f080c6047818ffffc31ffff86300030c0001e180003c00000200000000000020007186030e30e061c6380e70c700ee19c00d833800706ffbffefff7ffdffe8c03c38183707031fc1c0637c300c67e0018c7e03ff8ce07ff18e0ffe33e018c6fe0318fdc0631f1c0c6343818c6078300c0700018080000000000000000003001c00f003803c00700f000e03c001c0f000387c00077e0000ff00701f800e038001c000003bffffff7fffffcc3e000000f000000f800003f800006780001c380007038003c038007003800e0078008007800000600000000000000004000201c001e0781ffc3ffffe0f7ffe07cc6700f98ce01f7fffc0fffff81fc670e3d8ce1c73ffff807fffe1800dc030c7f8063ff700cf7ce01fc59c03e0338c61ffff8c3ffff18619c03fc33807f86700fc0ce000001c00000000000000001c00030300007060010f0ffff0f1fffe0f3fff80c001f060e07f1e1c0ee1e3fff81e7ffe01cfffc053019c1c6079c1ec1e381f8f0301b7c067ffffecfffffd9fffffb01f78060fe780c3cc3c187183c30430306000000@110$空瓶装水解谜$1808$27$165",
--}
--local index = addTSOcrDictEx(tab)
--toast(index);
--请自行更改参数
--1: 0,0,0,0 范围坐标，请自行修改
--2: "787878 , 797979" 偏色,多组或单组.请在偏色列表中选择
--3: 90 匹配精度 【0-100】
local ret = tsOcrText(index, 180, 170, 370, 230, "787878 , 797979", 70)
dialog("识别到的内容:"..ret)
]====] 


----找图
--x, y = findImage("空瓶装水解谜.png", 180, 170, 370, 230);--在（0,0）到（120,480）寻找刚刚截图的图片
--if x ~= -1 and y ~= -1 then        --如果在指定区域找到某图片符合条件
--	toast(x..y);                   --显示坐标
--else                               --如果找不到符合条件的图片
--	toast('没有找到图片!');        
--end


--getAccountInfo("http://ios.pettostudio.net/AccountInfo.aspx?action=GetIOSFullInfoByStateStr&state=success");
--local ts = require("ts");
--code,msg = ts.tsDownload("/var/mobile/Media/TouchSprite/gamelogo1.jpg","http://p0.so.qhmsg.com/sdr/720_1080_/t01f0c2107148464d50.jpg");

--local ts = require("ts");

--code,status = ts.tsDownload("1.jpg","http://ios.pettostudio.net/images/shuiping.png");
----同样支持ftp地址
----"1.jpg"（如只填文件名，默认保存到触动res目录下）
--dialog(code,0)
--dialog(status,0)


--recognize = ocrText(180, 170 , 490, 245, 1);  --OCR 英文识别
--mSleep(1000); 
--dialog("识别出的字符："..recognize, 0);
res = killVPN();
toast(tostring(res) .. ":killVPN",1);
--res = connectVPN();
--toast(tostring(res) .. ":connectVPN",1);